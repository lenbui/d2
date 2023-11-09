-- SPDX-License-Identifier: LPPL-1.3c+

require "lfs"

-- @param mode directly passed to D2. Recommended: png, svg, pdf (requires Apache Batik to convert svg to pdf)
function convertToDiagram(jobname, mode)
  local dTwoSourceFilename = jobname .. "-dtwo.d2"
  local dTwoTargetFilename = jobname .. "-dtwo." .. mode

  -- delete generated file to ensure they are really recreated
  os.remove(dTwoTargetFilename)

  if not (lfs.attributes(dTwoSourceFilename)) then
    texio.write_nl("Source " .. dTwoSourceFilename .. " does not exist.")
    return
  end

  texio.write("Executing D2... ")
  local cmd = "d2 --pad 0 " .. dTwoSourceFilename .. " " .. dTwoTargetFilename
  texio.write_nl(cmd)
  local handle,error = io.popen(cmd)
  if not handle then
    texio.write_nl("Error during execution of D2.")
    texio.write_nl(error)
    return
  end
  io.close(handle)

  if not (lfs.attributes(dTwoTargetFilename)) then
    texio.write_nl("D2 did not generate anything.")
    handle = io.open(dTwoTargetFilename, "w")
    handle:write("Error during latex code generation")
    io.close(handle)
    return
  end
end
