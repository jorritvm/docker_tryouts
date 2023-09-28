library(data.table)
dt = as.data.table(mtcars)
dt[, car := rownames(mtcars)]
print("I did some data.table stuff and am now showing the lowest mpg car:" )
print(dt[order(mpg)][1 , car])

      