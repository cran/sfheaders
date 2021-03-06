context("bbox")

test_that("bounding box correctly calculated", {


  bb <- function( x, cols = NULL ) {
    unname( unclass( sfheaders:::rcpp_calculate_bbox( x, cols ) ) )
  }

  expect_error( bb( 1L ), "geometries - incorrect size of bounding box")
  expect_error( bb( "a" ) )
  expect_error( bb( matrix(1L) ), "geometries - incorrect size of bounding box")
  expect_error( bb( matrix(1.2) ), "geometries - incorrect size of bounding box")

  bbox <- bb( 1L:2L )
  expect_equal( bbox, c(1,2,1,2) )

  bbox <- bb( c(1.0, 2.0) )
  expect_equal( bbox, c(1,2,1,2) )

  bbox <- bb( 1L:2L, c(0L,1L) )
  expect_equal( bbox, c(1,2,1,2) )

  bbox <- bb( c(1.0, 2.0), c(0L,1L) )
  expect_equal( bbox, c(1,2,1,2) )

  x <- matrix(c(0,0,0,1), ncol = 2 )
  bbox <- bb( x )
  expect_equal( bbox, c(0,0,0,1) )

  x <- matrix( c( 1, 2, 3, 4 ), ncol = 2 )
  bbox <- bb( x )
  expect_equal( bbox, c(1,3,2,4) )

  x <- matrix( c( 1, 2, 3, 4 ), ncol = 2, byrow = T )
  bbox <- bb( x )
  expect_equal( bbox, c(1,2,3,4) )

  x <- matrix( c( 1L:4L ), ncol = 2, byrow = T )
  bbox <- bb( x )
  expect_equal( bbox, c(1,2,3,4) )

  x <- matrix( c( 1.2, 2, 3, 4 ), ncol = 2, byrow = T )
  bbox <- bb( x, c(0,1) )
  expect_equal( bbox, c(1.2,2,3,4) )

  x <- matrix( c( 1L:4L ), ncol = 2, byrow = T )
  bbox <- bb( x, c(0L,1L) )
  expect_equal( bbox, c(1,2,3,4) )

  x <- matrix( c( 1L:4L ), ncol = 2, byrow = T )
  x <- as.data.frame( x )
  x <- as.matrix( x )
  bbox <- bb( x, c("V1","V2") )
  expect_equal( bbox, c(1,2,3,4) )

  x <- matrix( c( 1.2,2,3,4 ), ncol = 2, byrow = T )
  x <- as.data.frame( x )
  x <- as.matrix( x )
  bbox <- bb( x, c("V1","V2") )
  expect_equal( bbox, c(1.2,2,3,4) )

  x <- 1:2
  bbox <- bb( x, c("x","y") )
  expect_equal( bbox, c(1,2,1,2) )

  x <- c(1.1, 2)
  bbox <- bb( x, c("x","y") )
  expect_equal( bbox, c(1.1,2,1.1,2) )

  x <- data.frame( x = 1:5, y = 2:6 )
  bbox <- bb( x )
  expect_equal( bbox, c(1,2,5,6) )

  x <- 1
  expect_error( bb( x ), "geometries - incorrect size of bounding box")
  x <- matrix(1)
  expect_error( bb( x ), "geometries - incorrect size of bounding box")
  x <- matrix(1.1)
  expect_error( bb( x ), "geometries - incorrect size of bounding box")

})


test_that("z_range correctly calculated", {


  zr <- function( x ) {
    sfheaders:::rcpp_calculate_z_range( x )
  }

  err <- "sfheaders - incorrect size of z_range"

  expect_error( zr( 1L:2L ), err )
  expect_error( zr( c(1.2,2) ), err )

  expect_equal( zr(1:3), c(3,3) )
  expect_equal( zr(c(1.2,2,3)), c(3,3) )

  x <- matrix(c(0,0,0,1), ncol = 2 )
  expect_error( zr( x ), err )

  x <- matrix( c( 1, 2, 3, 4 ), ncol = 2 )
  expect_error( zr( x ), err )

  x <- matrix( c( 1, 2, 3, 4 ), ncol = 2, byrow = T )
  expect_error( zr( x ), err )

  x <- matrix( c( 1L:4L ), ncol = 2, byrow = T )
  expect_error( zr( x ), err )

  x <- data.frame( x = 1:5, y = 2:6 )
  expect_error( zr( x ), err )


  expect_equal( zr(1:3), c(3,3) )

  x <- matrix(c(1L:6L), ncol = 3)
  expect_equal( zr(x), c(5L,6L))

  x <- as.data.frame( matrix(c(1L:6L), ncol = 3) )
  expect_equal( zr(x), c(5L,6L))

})


test_that("m_range correctly calculated", {


  mr <- function( x, xyzm = "") {
    sfheaders:::rcpp_calculate_m_range( x, xyzm )
  }

  err <- "sfheaders - incorrect size of m_range"

  expect_error( mr( 1:2, "XY" ), err )
  expect_error( mr( 1:2, "XYM" ), err )
  expect_error( mr( 1:2, "XYZ" ), err )
  expect_error( mr( c(1.2,2.2) ), err )
  # expect_error( mr( 1:3 ), err )

  expect_equal( mr(1:4), c(4,4) )

  x <- matrix(c(0,0,0,0,0,0), ncol = 3 )
  expect_error( mr( x ), err )

  x <- matrix( c( 1, 2, 3, 4 ), ncol = 2 )
  expect_error( mr( x ), err )

  x <- matrix( c( 1, 2, 3, 4 ), ncol = 2, byrow = T )
  expect_error( mr( x ), err )

  x <- matrix( c( 1L:4L ), ncol = 2, byrow = T )
  expect_error( mr( x ), err )

  x <- data.frame( x = 1:5, y = 2:6 )
  expect_error( mr( x ), err )


  expect_equal( mr(1:4), c(4,4) )
  expect_equal( mr(c(1.2,2:4)), c(4,4) )

  x <- matrix(c(1L:8L), ncol = 4)
  expect_equal( mr(x), c(7L,8L))

  x <- matrix(c(1.1,2,3,4), ncol = 4)
  expect_equal( mr(x), c(4,4))

  x <- as.data.frame( matrix(c(1L:8L), ncol = 4) )
  expect_equal( mr(x), c(7,8))

})

## issue 59
test_that("bbox calculated on data.frame, sfg, sfc, sf", {

  df <- data.frame(
   id1 = c(1,1,1,1,1,1,1,1,2,2,2,2)
   , id2 = c(1,1,1,1,2,2,2,2,1,1,1,1)
   , x = c(0,0,1,1,1,1,2,2,3,4,4,3)
   , y = c(0,1,1,0,1,2,2,1,3,3,4,4)
  )

  expect_equal(unclass(unname(sf_bbox( df, x = "x", y = "y" ))), c(0,0,4,4))

  ## sfg objects
  pt <- sfg_point(obj = df[1, ], x = "x", y = "y", z = "id1")
  mpt <- sfg_multipoint(obj = df, x = "x", y = "y")
  ls <- sfg_linestring(obj = df, x = "x", y = "y")
  mls <- sfg_multilinestring(obj = df, x = "x", y = "y")
  p <- sfg_polygon(obj = df, x = "x" , y = "y")
  mp <- sfg_multipolygon(obj = df, x = "x", y = "y", close = FALSE )

  expect_equal(unclass(unname(sf_bbox( pt ))), c(0,0,0,0))
  expect_equal(unclass(unname(sf_bbox( mpt ))), c(0,0,4,4) )
  expect_equal(unclass(unname(sf_bbox( ls ))), c(0,0,4,4) )
  expect_equal(unclass(unname(sf_bbox( mls ))), c(0,0,4,4) )
  expect_equal(unclass(unname(sf_bbox( p ))), c(0,0,4,4) )
  expect_equal(unclass(unname(sf_bbox( mp ))), c(0,0,4,4) )

  ## sfc objects
  pt <- sfc_point(obj = df, x = "x", y = "y", z = "id1")
  mpt <- sfc_multipoint(obj = df, x = "x", y = "y", multipoint_id = "id1")
  ls <- sfc_linestring(obj = df, x = "x", y = "y", linestring_id = "id1")
  mls <- sfc_multilinestring(obj = df, x = "x", y = "y", multilinestring_id = "id1")
  p <- sfc_polygon(
    obj = df
    , x = "x"
    , y = "y"
    , polygon_id = "id1"
    , linestring_id = "id2"
    , close = FALSE
    )
  mp <- sfc_multipolygon(
    obj = df
    , x = "x"
    , y = "y"
    , multipolygon_id = "id1"
    , linestring_id = "id2"
    , close = FALSE
    )

  expect_equal(sf_bbox( pt ), attr(pt, "bbox"))
  expect_equal(sf_bbox( mpt ), attr(mpt, "bbox"))
  expect_equal(sf_bbox( ls ), attr(ls, "bbox"))
  expect_equal(sf_bbox( mls ), attr(mls, "bbox"))
  expect_equal(sf_bbox( p ), attr(p, "bbox"))
  expect_equal(sf_bbox( mp ), attr(mp, "bbox"))

  ## sf objects
  pt <- sf_point(obj = df, x = "x", y = "y", z = "id1")
  mpt <- sf_multipoint(obj = df, x = "x", y = "y", multipoint_id = "id1")
  ls <- sf_linestring(obj = df, x = "x", y = "y", linestring_id = "id1")
  mls <- sf_multilinestring(obj = df, x = "x", y = "y", multilinestring_id = "id1")
  p <- sf_polygon(
    obj = df
    , x = "x"
    , y = "y"
    , polygon_id = "id1"
    , linestring_id = "id2"
    , close = FALSE
    )
  mp <- sf_multipolygon(
    obj = df
    , x = "x"
    , y = "y"
    , multipolygon_id = "id1"
    , linestring_id = "id2"
    , close = FALSE
    )

  expect_equal(sf_bbox( pt ), attr(pt$geometry, "bbox"))
  expect_equal(sf_bbox( mpt ), attr(mpt$geometry, "bbox"))
  expect_equal(sf_bbox( ls ), attr(ls$geometry, "bbox"))
  expect_equal(sf_bbox( mls ), attr(mls$geometry, "bbox"))
  expect_equal(sf_bbox( p ), attr(p$geometry, "bbox"))
  expect_equal(sf_bbox( mp ), attr(mp$geometry, "bbox"))

})


test_that("z and m range correctly reported",{

  df <- data.frame(
    id1 = c(1,1,1,1,1,1,1,1,2,2,2,2)
    , id2 = c(1,1,1,1,2,2,2,2,1,1,1,1)
    , x = c(0,0,1,1,1,1,2,2,3,4,4,3)
    , y = c(0,1,1,0,1,2,2,1,3,3,4,4)
    , z = 1:12
    , m = 20:9
  )

  pt <- sf_point(obj = df, x = "x", y = "y", z = "z")
  mpt <- sf_multipoint(obj = df, x = "x", y = "y", z = "z", multipoint_id = "id1")
  ls <- sf_linestring(obj = df, x = "x", y = "y", z = "z", linestring_id = "id1")
  mls <- sf_multilinestring(obj = df, x = "x", y = "y", z = "z", multilinestring_id = "id1")
  p <- sf_polygon(
    obj = df
    , x = "x"
    , y = "y"
    , z = "z"
    , polygon_id = "id1"
    , linestring_id = "id2"
    , close = FALSE
  )
  mp <- sf_multipolygon(
    obj = df
    , x = "x"
    , y = "y"
    , z = "z"
    , multipolygon_id = "id1"
    , linestring_id = "id2"
    , close = FALSE
  )

 expect_true( all( attr( pt$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( mpt$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( ls$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( mls$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( p$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( mp$geometry, "z_range" ) == c(1,12) ) )

 expect_true( is.null( attr( pt$geometry, "m_range" ) ) )
 expect_true( is.null( attr( mp$geometry, "m_range" ) ) )
 expect_true( is.null( attr( ls$geometry, "m_range" ) ) )
 expect_true( is.null( attr( mls$geometry, "m_range" ) ) )
 expect_true( is.null( attr( p$geometry, "m_range" ) ) )
 expect_true( is.null( attr( mp$geometry, "m_range" ) ) )


 pt <- sf_point(obj = df, x = "x", y = "y", m = "m")
 mpt <- sf_multipoint(obj = df, x = "x", y = "y", m = "m", multipoint_id = "id1")
 ls <- sf_linestring(obj = df, x = "x", y = "y",  m = "m", linestring_id = "id1")
 mls <- sf_multilinestring(obj = df, x = "x", y = "y", m = "m", multilinestring_id = "id1")
 p <- sf_polygon(
   obj = df
   , x = "x"
   , y = "y"
   , m = "m"
   , polygon_id = "id1"
   , linestring_id = "id2"
   , close = FALSE
 )
 mp <- sf_multipolygon(
   obj = df
   , x = "x"
   , y = "y"
   , m = "m"
   , multipolygon_id = "id1"
   , linestring_id = "id2"
   , close = FALSE
 )

 expect_true( all( attr( pt$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( mpt$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( ls$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( mls$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( p$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( mp$geometry, "m_range" ) == c(9,20) ) )

 expect_true( is.null( attr( pt$geometry, "z_range" ) ) )
 expect_true( is.null( attr( mp$geometry, "z_range" ) ) )
 expect_true( is.null( attr( ls$geometry, "z_range" ) ) )
 expect_true( is.null( attr( mls$geometry, "z_range" ) ) )
 expect_true( is.null( attr( p$geometry, "z_range" ) ) )
 expect_true( is.null( attr( mp$geometry, "z_range" ) ) )


 pt <- sf_point(obj = df, x = "x", y = "y", z = "z", m = "m")
 mpt <- sf_multipoint(obj = df, x = "x", y = "y", z = "z", m = "m", multipoint_id = "id1")
 ls <- sf_linestring(obj = df, x = "x", y = "y", z = "z", m = "m", linestring_id = "id1")
 mls <- sf_multilinestring(obj = df, x = "x", y = "y", z = "z", m = "m", multilinestring_id = "id1")
 p <- sf_polygon(
   obj = df
   , x = "x"
   , y = "y"
   , z = "z"
   , m = "m"
   , polygon_id = "id1"
   , linestring_id = "id2"
   , close = FALSE
 )
 mp <- sf_multipolygon(
   obj = df
   , x = "x"
   , y = "y"
   , z = "z"
   , m = "m"
   , multipolygon_id = "id1"
   , linestring_id = "id2"
   , close = FALSE
 )

 expect_true( all( attr( pt$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( mpt$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( ls$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( mls$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( p$geometry, "z_range" ) == c(1,12) ) )
 expect_true( all( attr( mp$geometry, "z_range" ) == c(1,12) ) )

 expect_true( all( attr( pt$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( mpt$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( ls$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( mls$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( p$geometry, "m_range" ) == c(9,20) ) )
 expect_true( all( attr( mp$geometry, "m_range" ) == c(9,20) ) )

})

test_that("C++ functions correctly 'guess' the dimension", {
  ## i.e. when xyzm == ""
  df <- data.frame(x = 1, y = 2)

  res <- sfheaders:::rcpp_sfg_linestring(
    x = df
    , geometry_columns = c("x","y")
    , xyzm = ""
  )
  expect_true( attr( res , "class" )[1] == "XY" )

  df <- data.frame(x = 1, y = 2, z = 3)

  res <- sfheaders:::rcpp_sfg_linestring(
    x = df
    , geometry_columns = c("x","y","z")
    , xyzm = ""
  )
  expect_true( attr( res , "class" )[1] == "XYZ" )


  ## Going into the C++ API, with defining 'xyzm', it has to 'guess' what the dimension is
  df <- data.frame(x = 1, y = 2, m = 3)
  res <- sfheaders:::rcpp_sfg_linestring(
    x = df
    , geometry_columns = c("x","y","m")
    , xyzm = ""
  )
  expect_true( attr( res , "class" )[1] == "XYZ" )

  df <- data.frame(x = 1, y = 2, z = 3, m = 4)
  res <- sfheaders:::rcpp_sfg_linestring(
    x = df
    , geometry_columns = c("x","y","m")
    , xyzm = ""
  )
  expect_true( attr( res , "class" )[1] == "XYZ" )

  df <- data.frame(x = 1, y = 2, z = 3, m = 4)
  res <- sfheaders:::rcpp_sfg_linestring(
    x = df
    , geometry_columns = c("x","y","z", "m")
    , xyzm = ""
  )
  expect_true( attr( res , "class" )[1] == "XYZM" )


})

