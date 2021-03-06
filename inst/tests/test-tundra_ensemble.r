context('tundra ensemble')

assign('tundra_simple', source('tundra_simple.r')$value, envir = globalenv())

test_that('the simple tundra model works correctly', {
  simple_model <- tundra_simple(, list(twiddle = 0))
  simple_model$train(iris)
  expect_equal(simple_model$predict(iris[1, ]), iris[1,1])
  expect_equal(simple_model$predict(iris[1:2, ]), rep(iris[1,1], 2))
})

test_that('it correctly trains a trivial ensemble', {
  twiddle <- runif(10, 0, 1)
  num_buckets <- 10
  test_ensemble <- tundra_ensemble(list(), list(
    validation_buckets = num_buckets,
    master = list('simple', master = TRUE),
    submodels = lapply(twiddle, function(tw) list('simple', twiddle = tw))
  ))
  test_ensemble$train(iris)
  expect_equal(test_ensemble$predict(iris[1,]),
               iris[1 + floor(nrow(iris) / num_buckets), 1] + twiddle[1] +
               iris[1, 1] * length(twiddle) + sum(twiddle))
})

rm(tundra_simple, envir = globalenv())

