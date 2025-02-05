 local _local_1_ = string local fmt = _local_1_["format"]
 local _local_2_ = vim local uv = _local_2_["loop"]

 local function execute_request(args, on_exit) _G.assert((nil ~= on_exit), "Missing argument on-exit on ./fnl/paperplanes/curl.fnl:4") _G.assert((nil ~= args), "Missing argument args on ./fnl/paperplanes/curl.fnl:4")
 local io = {stdout = uv.new_pipe(false), stderr = uv.new_pipe(false), output = {}, errput = {}} local save_io



 local function _3_(into, err, data)
 assert(not err, err)
 return table.insert(into, data) end save_io = _3_
 local opts = {args = args, stdio = {nil, io.stdout, io.stderr}} local exit
 local function _4_(exit_code)
 uv.close(io.stdout)
 uv.close(io.stderr)
 local errors = table.concat(io.errput)
 local output = table.concat(io.output)
 return on_exit(exit_code, output, errors) end exit = vim.schedule_wrap(_4_)
 uv.spawn("curl", opts, exit)
 local function _6_() local _5_ = io.errput local function _7_(...) return save_io(_5_, ...) end return _7_ end uv.read_start(io.stderr, _6_())
 local function _9_() local _8_ = io.output local function _10_(...) return save_io(_8_, ...) end return _10_ end return uv.read_start(io.stdout, _9_()) end

 local function curl(request_args, response_handler)
 assert((vim.fn.executable("curl") == 1), fmt("paperplanes.nvim could not find %q executable", "curl"))








 local args = vim.tbl_flatten({"--silent", "--show-error", "--write-out", "\n%{response_code}", request_args}) local on_exit



 local function _11_(exit_code, output, errors)

 assert(("" == errors), fmt("paperplanes encountered an internal error: %q", errors))

 assert((0 == exit_code), fmt("curl exited with non-zero status: %q", exit_code))




 local response, status = string.match(output, "(.*)\n(%d+)$")
 local status0 = tonumber(status)
 return response_handler(response, status0) end on_exit = _11_
 return execute_request(args, on_exit) end

 return curl