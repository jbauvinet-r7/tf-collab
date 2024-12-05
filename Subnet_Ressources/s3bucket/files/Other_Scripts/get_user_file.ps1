Set-Item WSMan:\localhost\Client\TrustedHosts -Value "10.0.10.100" -Force
# Define variables
$remoteServer = "10.0.10.100" # Replace with the remote server address
$remoteFilePath = "C:\adusers_list.csv" # Replace with the path to the remote file
$localDestination = "C:\adusers_list.csv" # Replace with the local destination path where you want to save the file
# Prompt for credentials
$cred = Get-Credential
# Create a session to the remote server with specified credentials
$session = New-PSSession -ComputerName $remoteServer -Credential $cred
# Copy the file from the remote server to the local machine
Copy-Item -Path $remoteFilePath -Destination $localDestination -FromSession $session
# Close the session
Remove-PSSession $session
Write-Host "File downloaded successfully to $localDestination"

