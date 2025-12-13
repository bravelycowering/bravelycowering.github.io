local file = require "file"

local outfile = assert(io.open(arg[2], "wb"))
outfile:write(file(arg[1]))
outfile:close()