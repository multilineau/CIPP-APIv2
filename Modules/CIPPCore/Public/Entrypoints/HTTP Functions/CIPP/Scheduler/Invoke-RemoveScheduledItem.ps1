using namespace System.Net

Function Invoke-RemoveScheduledItem {
    <#
    .FUNCTIONALITY
        Entrypoint,AnyTenant
    .ROLE
        CIPP.Scheduler.ReadWrite
    #>
    [CmdletBinding()]
    param($Request, $TriggerMetadata)

    $APIName = 'RemoveScheduledItem'
    $User = $Request.Headers

    $task = @{
        RowKey       = $Request.Query.id ? $Request.Query.id : $Request.Body.id
        PartitionKey = 'ScheduledTask'
    }
    $Table = Get-CIPPTable -TableName 'ScheduledTasks'
    Remove-AzDataTableEntity -Force @Table -Entity $task

    Write-LogMessage -Headers $User -API $APINAME -message "Task removed: $($task.RowKey)" -Sev 'Info'

    Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
            StatusCode = [HttpStatusCode]::OK
            Body       = @{ Results = 'Task removed successfully.' }
        })


}
