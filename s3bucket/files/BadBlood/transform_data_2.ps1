# Define variables
$sourceFilePath = "C:\adusers_list.csv" # Path to the CSV file
$outputFilePath = "C:\users.csv" # Path to save the transformed data
$userCities = @("Boston", "Arlington", "Austin", "Tampa", "Reading", "Belfast", "Dublin", "Galway", "Munich", "Paris", "Prague","Melbourne","Singapore","Tel Aviv","Tokyo","Bangalore") # List of user cities

# Define IP ranges for each city
$cityIPRanges = @{
    "Boston" = "10.1.0.0-10.1.255.255"
    "Arlington" = "10.2.0.0-10.2.255.255"
    "Austin" = "10.3.0.0-10.3.255.255"
    "Tampa" = "10.4.0.0-10.4.255.255"
    "Reading" = "10.5.0.0-10.5.255.255"
    "Belfast" = "10.6.0.0-10.6.255.255"
    "Dublin" = "10.7.0.0-10.7.255.255"
    "Galway" = "10.8.0.0-10.8.255.255"
    "Munich" = "10.9.0.0-10.9.255.255"
    "Paris" = "10.10.0.0-10.10.255.255"
    "Prague" = "10.11.0.0-10.11.255.255"
    "Melbourne" = "10.12.0.0-10.12.255.255"
    "Singapore" = "10.13.0.0-10.13.255.255"
    "Tel Aviv" = "10.14.0.0-10.14.255.255"
    "Tokyo" = "10.15.0.0-10.15.255.255"
    "Bangalore" = "10.16.0.0-10.16.255.255"
}

# Define state abbreviations for each city
$cityStates = @{
    "Boston" = "us"
    "Arlington" = "us"
    "Austin" = "us"
    "Tampa" = "us"
    "Reading" = "gb"
    "Belfast" = "ie"
    "Dublin" = "ie"
    "Galway" = "ie"
    "Munich" = "de"
    "Paris" = "fr"
    "Prague" = "cz"
    "Melbourne" = "au"
    "Singapore" = "sg"
    "Tel Aviv" = "il"
    "Tokyo" = "jp"
    "Bangalore" = "in"
}


# Generate random IP address within the specified range for a city
function Get-RandomIPAddress {
    param (
        [string]$IPRange,
        [System.Collections.Generic.List[string]]$GeneratedIPs
    )

    # Ensure $GeneratedIPs list is initialized
    if (-not $GeneratedIPs) {
        $GeneratedIPs = New-Object System.Collections.Generic.List[string]
    }

    # Split the IP range into start and end addresses
    $startIP = $IPRange.Split("-")[0]
    $endIP = $IPRange.Split("-")[1]

    # Extract individual octets from start and end IPs
    $startOctets = $startIP -split "\."
    $endOctets = $endIP -split "\."

    # Convert octets to integers
    $startOctetInts = @()
    $endOctetInts = @()
    foreach ($octet in $startOctets) {
        $startOctetInts += [int]$octet
    }
    foreach ($octet in $endOctets) {
        $endOctetInts += [int]$octet
    }

    # Generate random numbers for each octet within its valid range
    $randomOctets = @()
    do {
        $isDuplicate = $false
        for ($i = 0; $i -lt 4; $i++) {
            # Exclude 0, 254, and 255
            $excludeRange = @(0, 254, 255)
            do {
                $randomOctet = Get-Random -Minimum $startOctetInts[$i] -Maximum ($endOctetInts[$i] + 1)
            } while ($excludeRange -contains $randomOctet)
            $randomOctets += $randomOctet
        }

        # Construct the randomly generated IP address
        $randomIP = $randomOctets -join "."

        # Check if the generated IP address is already in the list of generated IPs
        if ($GeneratedIPs -contains $randomIP) {
            $isDuplicate = $true
            $randomOctets = @()  # Clear the random octets array for regeneration
        } else {
            $GeneratedIPs.Add($randomIP)  # Add the generated IP to the list of generated IPs
        }
    } while ($isDuplicate)

    # Return the randomly generated IP address
    return $randomIP
}





# Generate random MAC address
function Get-RandomMAC {
    $chars = '0123456789ABCDEF'
    $mac = ''
    for ($i = 0; $i -lt 6; $i++) {
        $mac += $chars[(Get-Random -Maximum 16)]
        $mac += $chars[(Get-Random -Maximum 16)]
        if ($i -lt 5) {
            $mac += ':'
        }
    }
    return $mac
}

# Define usernames to avoid
$UsernamesToAvoid = @("mmoose", "Administrator","Guest","krbtgt","idr_service_account")

# Read the CSV file line by line
$lines = Get-Content -Path $sourceFilePath -Encoding UTF8

# Initialize an array to store transformed data
$transformedData = @()
$header = "nameuser,ipint,usergroup,country,usermac,userworkstation,firstname,lastname,usercity"
$transformedData += $header

# Iterate through each line
foreach ($line in $lines) {
    # Skip header line
    if ($line -notlike '"DistinguishedName","Name","UserPrincipalName"*') {
        # Split the line into an array of values
        $values = $line -split '","'
        
        # Extract required fields
        $nameUser = ($values[1] -replace 'CN=' -replace ',.*').TrimEnd('"').ToLower()            
        # Check if the username should be avoided
        if ($UsernamesToAvoid -notcontains $nameUser -and $nameUser -notmatch '\d{1,10}\w{2}') {
            Write-Host "Processing username: $nameUser"   
            $distinguishedName = $values[0] -replace 'CN='
            $ou = ($distinguishedName -split ',')[1] -replace 'OU='
            $userGroup = $ou -replace ',.*'
            $userCity = Get-Random -InputObject $userCities
            $userCityIPRange = $cityIPRanges[$userCity]
            $userIPInt = Get-RandomIPAddress -IPRange $userCityIPRange
            $userMac = Get-RandomMAC
            $userWorkstation = "ws-" + $nameUser
            $fullName = $values[1] -replace ',.*'
            $firstName = $fullName -split '_' | Select-Object -First 1
            $lastName = $fullName -split '_' | Select-Object -Last 1
            $state = $cityStates[$userCity]

            # Add transformed data to the array
            $transformedData += "$nameUser,$userIPInt,$userGroup,$state,$userMac,$userWorkstation,$firstName,$lastName,$userCity"
        }
        else{
        Write-Host "Not Processing username: $nameUser (Exclusions or Digits Only)"
        }
    }
}

# Save the transformed data to a new CSV file
$transformedData | Out-File -FilePath $outputFilePath -Encoding UTF8

Write-Host "Transformation completed. Transformed data saved to $outputFilePath"
