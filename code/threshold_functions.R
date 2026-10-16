# threshold_functions.R -- Hansen (1999) fixed-effect panel threshold regression, with
#   * high-dimensional fixed effects (via fixest::demean), any number of threshold regressors
#   * wild cluster (Rademacher) bootstrap of the threshold test, clustering by LA
#   * likelihood-ratio confidence sets for the threshold (Hansen 2000, c(0.95) = 7.35)
#   * sequential double-threshold search
# Model:  y_it = a_i + FE + sum_r  b_r' x_it 1(q_it in regime r) + g' z_it + e_it

suppressPackageStartupMessages(library(fixest))

.dm <- function(M, fe_df) {
  M <- as.matrix(M)
  out <- fixest::demean(M, f = fe_df, nthreads = 1)
  out <- as.matrix(out); colnames(out) <- colnames(M); out
}

.regime_X <- function(X, q, cuts, shift = FALSE) {
  br <- c(-Inf, sort(cuts), Inf)
  reg <- cut(q, br, labels = FALSE, right = TRUE)
  out <- do.call(cbind, lapply(seq_len(length(br) - 1), function(r) {
    m <- X * (reg == r); colnames(m) <- paste0(colnames(X), "_r", r); m
  }))
  if (shift) {  # regime-specific intercepts (level jumps) for regimes 2..R
    D <- sapply(2:(length(br) - 1), function(r) as.numeric(reg == r))
    D <- matrix(D, ncol = length(br) - 2); colnames(D) <- paste0("jump_r", 2:(length(br) - 1))
    out <- cbind(out, D)
  }
  out
}

.ssr <- function(y, X) { f <- lm.fit(X, y); sum(f$residuals^2) }

# grid of candidate thresholds: quantiles of q, trimming so that each regime keeps >= trim share of obs
.make_grid <- function(q, trim = 0.10, step = 0.0125) {
  unique(quantile(q, seq(trim, 1 - trim, by = step), names = FALSE, type = 1))
}

hansen_fe <- function(d, y, x, q, z = NULL, fe = c("code", "region_year"), cluster = "code",
                      trim = 0.10, step = 0.0125, nboot = 499, seed = 20261008, double = TRUE, shift = FALSE) {
  set.seed(seed)
  d <- as.data.frame(d)
  fe_df <- d[, fe, drop = FALSE]
  Y <- .dm(d[, y, drop = FALSE], fe_df)[, 1]
  X <- as.matrix(d[, x, drop = FALSE]); colnames(X) <- x
  Zd <- if (length(z)) .dm(d[, z, drop = FALSE], fe_df) else NULL
  qv <- d[[q]]
  n <- length(Y); G <- d[[cluster]]
  dof <- n - sum(sapply(fe, function(f) length(unique(d[[f]])))) - 2 * ncol(X) - shift - ifelse(is.null(Zd), 0, ncol(Zd))
  grid <- .make_grid(qv, trim, step)

  # precompute demeaned design for each candidate threshold
  Xd0 <- cbind(.dm(X, fe_df), Zd)
  design <- lapply(grid, function(g) qr(cbind(.dm(.regime_X(X, qv, g, shift), fe_df), Zd)))
  S0 <- .ssr(Y, Xd0)
  S1 <- sapply(design, function(Q) sum(qr.resid(Q, Y)^2))
  i1 <- which.min(S1); g1 <- grid[i1]
  sig2 <- S1[i1] / dof
  F1 <- (S0 - S1[i1]) / sig2
  LR <- (S1 - S1[i1]) / sig2
  ci <- range(grid[LR <= 7.35])

  # wild cluster bootstrap under H0: no threshold
  f0 <- lm.fit(Xd0, Y); yhat0 <- Y - f0$residuals; e0 <- f0$residuals
  ug <- unique(G); gi <- match(G, ug)
  boot1 <- numeric(nboot)
  for (b in seq_len(nboot)) {
    w <- sample(c(-1, 1), length(ug), replace = TRUE)[gi]
    yb <- .dm(matrix(yhat0 + e0 * w, ncol = 1, dimnames = list(NULL, "y")), fe_df)[, 1]
    s0 <- .ssr(yb, Xd0)
    s1 <- min(sapply(design, function(Q) sum(qr.resid(Q, yb)^2)))
    boot1[b] <- (s0 - s1) / (s1 / dof)
  }
  p1 <- mean(boot1 >= F1)

  res <- list(grid = grid, S1 = S1, LR = LR, gamma1 = g1, ci1 = ci, F1 = F1, p1 = p1, boot1 = boot1,
              n = n, dof = dof, x = x, q = q, S0 = S0)

  if (double) {
    # second threshold given gamma1 (sequential), trimming 10% within each regime
    ok <- sapply(grid, function(g) {
      if (abs(g - g1) < 1e-8) return(FALSE)
      reg <- cut(qv, c(-Inf, sort(c(g1, g)), Inf), labels = FALSE)
      all(tabulate(reg, 3) >= trim * n)
    })
    g2grid <- grid[ok]
    if (length(g2grid)) {
      design2 <- lapply(g2grid, function(g) qr(cbind(.dm(.regime_X(X, qv, c(g1, g), shift), fe_df), Zd)))
      S2 <- sapply(design2, function(Q) sum(qr.resid(Q, Y)^2))
      i2 <- which.min(S2); g2 <- g2grid[i2]
      sig2b <- S2[i2] / (dof - ncol(X))
      F2 <- (S1[i1] - S2[i2]) / sig2b
      # bootstrap under H0: single threshold at g1
      Q1 <- design[[i1]]; e1 <- qr.resid(Q1, Y); yhat1 <- Y - e1
      boot2 <- numeric(nboot)
      for (b in seq_len(nboot)) {
        w <- sample(c(-1, 1), length(ug), replace = TRUE)[gi]
        yb <- .dm(matrix(yhat1 + e1 * w, ncol = 1, dimnames = list(NULL, "y")), fe_df)[, 1]
        s1 <- min(sapply(design, function(Q) sum(qr.resid(Q, yb)^2)))
        s2 <- min(sapply(design2, function(Q) sum(qr.resid(Q, yb)^2)))
        boot2[b] <- (s1 - s2) / (s2 / (dof - ncol(X)))
      }
      res$gamma2 <- g2; res$F2 <- F2; res$p2 <- mean(boot2 >= F2); res$g2grid <- g2grid; res$S2 <- S2
    }
  }
  # coefficients at gamma1 (and gamma2 if significant at 10%) with LA-clustered SEs
  cuts <- if (!is.null(res$p2) && res$p2 < 0.10) sort(c(g1, res$gamma2)) else g1
  RX <- .regime_X(X, qv, cuts, shift)
  dd <- cbind(d, RX)
  fml <- as.formula(paste(y, "~", paste(c(colnames(RX), z), collapse = " + "), "|", paste(fe, collapse = " + ")))
  res$fit <- feols(fml, dd, cluster = as.formula(paste0("~", cluster)))
  res$cuts <- cuts
  res$regime_n <- tabulate(cut(qv, c(-Inf, cuts, Inf), labels = FALSE), length(cuts) + 1)
  res$regime_la <- sapply(seq_len(length(cuts) + 1), function(r)
    length(unique(d[[cluster]][cut(qv, c(-Inf, cuts, Inf), labels = FALSE) == r])))
  res
}

summarise_hansen <- function(h, label) {
  ct <- coeftable(h$fit)
  data.frame(model = label, gamma1 = h$gamma1, ci_lo = h$ci1[1], ci_hi = h$ci1[2], F1 = h$F1, p_boot1 = h$p1,
             gamma2 = ifelse(is.null(h$gamma2), NA, h$gamma2), F2 = ifelse(is.null(h$F2), NA, h$F2),
             p_boot2 = ifelse(is.null(h$p2), NA, h$p2), n = h$n,
             regimes_obs = paste(h$regime_n, collapse = "/"), regimes_la = paste(h$regime_la, collapse = "/"),
             stringsAsFactors = FALSE)
}

# Cross-sectional threshold (Hansen 2000) with heteroskedastic wild bootstrap; allows a regime intercept
hansen_cs <- function(d, y, x, q, z = NULL, fe = NULL, trim = 0.15, step = 0.01, nboot = 999, seed = 20261008) {
  set.seed(seed); d <- as.data.frame(d)
  mk <- function(M) { M <- as.matrix(M); if (!is.null(fe)) .dm(M, d[, fe, drop = FALSE]) else cbind(1, M) }
  Y <- if (!is.null(fe)) .dm(d[, y, drop = FALSE], d[, fe, drop = FALSE])[, 1] else d[[y]]
  qv <- d[[q]]; X <- as.matrix(d[, x, drop = FALSE]); colnames(X) <- x
  Z <- if (length(z)) as.matrix(d[, z, drop = FALSE]) else NULL
  grid <- .make_grid(qv, trim, step)
  X0 <- mk(cbind(X, Z)); S0 <- .ssr(Y, X0)
  des <- lapply(grid, function(g) qr(mk(cbind(.regime_X(X, qv, g), above = as.numeric(qv > g), Z))))
  S1 <- sapply(des, function(Q) sum(qr.resid(Q, Y)^2)); i1 <- which.min(S1)
  n <- length(Y); k <- ncol(des[[i1]]$qr); sig2 <- S1[i1] / (n - k)
  F1 <- (S0 - S1[i1]) / sig2; LR <- (S1 - S1[i1]) / sig2
  f0 <- lm.fit(X0, Y); e0 <- f0$residuals; yh <- Y - e0
  bt <- replicate(nboot, {
    yb <- yh + e0 * sample(c(-1, 1), n, TRUE)
    s0 <- .ssr(yb, X0); s1 <- min(sapply(des, function(Q) sum(qr.resid(Q, yb)^2)))
    (s0 - s1) / (s1 / (n - k))
  })
  list(grid = grid, LR = LR, gamma1 = grid[i1], ci1 = range(grid[LR <= 7.35]), F1 = F1, p1 = mean(bt >= F1), n = n)
}


# Continuous kink (regression-kink / hinge) model: y = b1*q + b2*(q - tau)_+ + controls + FE.
# Tests H0: b2 = 0 with a sup-F statistic and wild cluster bootstrap; returns the slope below/above tau.
hansen_kink <- function(d, y, q, z = NULL, fe = "region_year", cluster = "code", trim = 0.10, step = 0.0125,
                        nboot = 499, seed = 20261008) {
  set.seed(seed); d <- as.data.frame(d); fe_df <- d[, fe, drop = FALSE]
  Y <- .dm(d[, y, drop = FALSE], fe_df)[, 1]; qv <- d[[q]]
  Zd <- if (length(z)) .dm(d[, z, drop = FALSE], fe_df) else NULL
  Q <- .dm(matrix(qv, ncol = 1, dimnames = list(NULL, "q")), fe_df)
  X0 <- cbind(Q, Zd); S0 <- .ssr(Y, X0)
  grid <- .make_grid(qv, trim, step)
  des <- lapply(grid, function(g) qr(cbind(Q, .dm(matrix(pmax(qv - g, 0), ncol = 1, dimnames = list(NULL, "h")), fe_df), Zd)))
  S1 <- sapply(des, function(QR) sum(qr.resid(QR, Y)^2)); i1 <- which.min(S1)
  n <- length(Y); dof <- n - sum(sapply(fe, function(f) length(unique(d[[f]])))) - 2 - ifelse(is.null(Zd), 0, ncol(Zd))
  sig2 <- S1[i1] / dof; F1 <- (S0 - S1[i1]) / sig2; LR <- (S1 - S1[i1]) / sig2
  f0 <- lm.fit(X0, Y); e0 <- f0$residuals; yh <- Y - e0; G <- d[[cluster]]; ug <- unique(G); gi <- match(G, ug)
  bt <- replicate(nboot, {
    yb <- .dm(matrix(yh + e0 * sample(c(-1, 1), length(ug), TRUE)[gi], ncol = 1, dimnames = list(NULL, "y")), fe_df)[, 1]
    s0 <- .ssr(yb, X0); s1 <- min(sapply(des, function(QR) sum(qr.resid(QR, yb)^2))); (s0 - s1) / (s1 / dof)
  })
  g <- grid[i1]; dd <- d; dd$hinge <- pmax(qv - g, 0)
  fit <- feols(as.formula(paste(y, "~", paste(c(q, "hinge", z), collapse = " + "), "|", paste(fe, collapse = "+"))),
               dd, cluster = as.formula(paste0("~", cluster)))
  above <- tryCatch({ b <- coef(fit)[c(q, "hinge")]; V <- vcov(fit)[c(q, "hinge"), c(q, "hinge")]
    c(est = sum(b), se = sqrt(sum(V))) }, error = function(e) c(est = NA, se = NA))
  list(gamma = g, ci = range(grid[LR <= 7.35]), F = F1, p = mean(bt >= F1), fit = fit, grid = grid, LR = LR,
       slope_below = coef(fit)[q], se_below = se(fit)[q], slope_above = above["est"], se_above = above["se"], n = n)
}
