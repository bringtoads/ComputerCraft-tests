-- Function to download a file from a URL and save it to a specified path
function downloadScript(url, filename)
    local response = http.get(url)

    if response then 
        local file = fs.open(filename, "w")
        file.write(response.readAll())
        file.close()
        response.close()
        print("File downloaded successfully: " .. filename)
    else
        print("Failed to load: " .. filename)
        print("HTTP Error Code: " .. response.getResponseCode())  -- Print the error code if available
    end
end

-- URL of the script to download (use the raw URL)
local url = "https://raw.githubusercontent.com/bringtoads/ComputerCraft-tests/master/turtletest.lua"  -- Use the raw link here
local filename = "your-script.lua"  -- Desired local filename

-- Call the function to download the script
downloadScript(url, filename)
