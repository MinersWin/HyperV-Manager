[void][system.reflection.Assembly]::LoadWithPartialName("MySql.Data")
$connStr = "server=root1.minerswin.de;Persist Security Info=false;user id=" + $dbusername + ";pwd=" + $dbpassword + ";"
$conn = New-Object MySQL.Data.MySqlClient.MySqlConnection($connStr)
$conn.Open()
