Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Time Zone Selection"
$form.Size = New-Object System.Drawing.Size(600, 300)
$form.StartPosition = 'CenterScreen'

# Create a label for the time zone currently being used
$currentTZLabel = New-Object System.Windows.Forms.Label
$currentTZLabel.Location = New-Object System.Drawing.Point(10, 130)
$currentTZLabel.AutoSize = $true
$currentTimeZone = (Get-TimeZone).Id
$currentTZLabel.Text = "Current System Time Zone: $currentTimeZone"
$form.Controls.Add($currentTZLabel)

# Create a label for the question
$questionLabel = New-Object System.Windows.Forms.Label
$questionLabel.Location = New-Object System.Drawing.Point(10, 20)
$questionLabel.AutoSize = $true
$questionLabel.Text = "Select the time zone you want to be in:"
$form.Controls.Add($questionLabel)

# Create a dropdown (ComboBox) for selection
$timeZonecomboBox = New-Object System.Windows.Forms.ComboBox
$timeZonecomboBox.Location = New-Object System.Drawing.Point(250, 15)
$timeZonecomboBox.Width = 200
$timeZoneArray = @("Pacific Standard Time", "Mountain Standard Time", "Central Standard Time", "Eastern Standard Time")
$timeZonecomboBox.Items.AddRange($timeZoneArray)
$form.Controls.Add($timeZonecomboBox)

# Create a submitButton to submit the choice
$submitButton = New-Object System.Windows.Forms.button
$submitButton.Location = New-Object System.Drawing.Point(250, 70)
$submitButton.Text = "Submit"
$submitButton.Add_Click({
    $selectedTimeZone = $timeZonecomboBox.SelectedItem
    $currentTimeZone = (Get-TimeZone).Id #resets TZ in the case that it was already changed in this session


    if (-not ($timeZoneArray -contains $selectedTimeZone)) {
        [System.Windows.Forms.MessageBox]::Show("You must pick something")

    } elseif ($selectedTimeZone -eq $currentTimeZone) {
        [System.Windows.Forms.MessageBox]::Show("Selection is the same as your current time zone - No changes were made")
        
    } else {
        # change time zone here!
        Set-TimeZone -Name "$selectedTimeZone"
        $currentTZLabel.Text = "Current System Time Zone: $selectedTimeZone"
        # TODO: Add a way to disable to "automatically set time zone" setting in windows
        [System.Windows.Forms.MessageBox]::Show("Time zone changed to $selectedTimeZone")
    }

})
$form.Controls.Add($submitButton)

# Display the form
$form.ShowDialog()

