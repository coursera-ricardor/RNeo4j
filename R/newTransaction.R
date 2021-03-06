newTransaction = function(graph) UseMethod("newTransaction")

newTransaction.default = function(x) {
  stop("Invalid object. Must supply graph object.")
}

newTransaction.graph = function(graph) {
  url = attr(graph, "transaction")
  header = setHeaders(graph)
  h = basicHeaderGatherer()
  t = basicTextGatherer()
  opts = list(customrequest = "POST",
              httpheader = header,
              writefunction = t$update, 
              headerfunction = h$update)
  curlPerform(url = url, .opts = opts)
  text = t$value()
  headers = h$value()
  location = headers["Location"][[1]]
  commit = fromJSON(text)$commit
  transaction = list(location = location, commit = commit)
  attr(transaction, "auth_token") = attr(graph, "auth_token")
  class(transaction) = "transaction"
  return(transaction)
}