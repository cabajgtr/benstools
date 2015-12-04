require(RODBC)

sql <- "SELECT SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,GIN, TT_CUSTOMER, POS_YEAR, SEASON, POS_MTH_NBR, POS_WK_NBR, SUM(POS_UNITS) as units,SUM(POS_SALES) as sales, SUM(LISTED) AS LISTED, SUM(STORECT) AS STORECT,SUM(INSTOCK) AS INSTOCK, POS_WK_END_DT
          FROM R_POS_WITH_LLINSTOCK
          WHERE SEGMENT2 NOT IN  ('SPECIALS','LEGACY')
          AND SEGMENT2 NOT LIKE ('OTHER%')
          AND POS_YEAR > 2010
          GROUP BY SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,GIN, POS_YEAR, SEASON, POS_MTH_NBR, POS_WK_NBR, TT_CUSTOMER, POS_WK_END_DT
          HAVING SUM(POS_UNITS) <> 0
          ORDER BY SEGMENT4, TT_CUSTOMER, POS_YEAR, POS_MTH_NBR, POS_WK_NBR"

sql_promo <- "SELECT * from vPROMO_TOYS"

#' A SQL query function, preconnected to SPREPORTING
#'
#' This function runs SQL on SPREPORTING.
#' @param sql SQL code to run
#' @keywords SQL
#' @export

qryResults <- function(sql) {
     conn <- odbcDriverConnect('driver={SQL Server};server=NAEMSQL02\\SPREPORTING;database=SP_REPORTING;trusted_connection=true')
    print("connected")
     sql <- strwrap(sql, width=10000, simplify=TRUE)
     TOYS <- data.table(sqlQuery(conn, sql))
     odbcClose(conn)
     return(TOYS)
}
