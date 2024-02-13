$configurationPath = "snowagent.config" # Update to your actual configuration file path

# Load the XML configuration file
[xml]$config = Get-Content -Path $configurationPath

# Extract all endpoints from the configuration
$endpoints = $config.AgentConfiguration.Endpoints.Endpoint

foreach ($endpoint in $endpoints) {
    $address = $endpoint.Address.Split(":")[1].Trim("//")
    $port = $endpoint.Address.Split(":")[2]

    try {
        # Ping the address
        $pingResult = Test-Connection -ComputerName $address -Count 1 -ErrorAction Stop
        Write-Host "Ping to $address successful."

        # If ping is successful, check if the port is open
        $tcpTest = New-Object System.Net.Sockets.TcpClient
        $tcpTest.Connect($address, $port)
        if ($tcpTest.Connected) {
            Write-Host "Port $port on $address is open."
        } else {
            Write-Host "Port $port on $address is closed."
        }
        $tcpTest.Close()
    } catch {
        Write-Host "Ping to $address failed or port $port is not open."
    }
}
