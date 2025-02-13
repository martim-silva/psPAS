# .ExternalHelp psPAS-help.xml
Function Get-PASPTARiskSummary {
    [CmdletBinding()]
    param( )

    BEGIN {
        Assert-VersionRequirement -RequiredVersion 13.2
    }#begin

    PROCESS {

        #Create request URL
        $URI = "$Script:BaseURI/API/pta/API/Risks/Summary/"

        #Send request to web service
        $result = Invoke-PASRestMethod -Uri $URI -Method GET -WebSession $Script:WebSession

        If ($null -ne $result) {

            #Return Results
            $result | Add-ObjectDetail -typename psPAS.CyberArk.Vault.PTA.Event.Risk.Summary

        }

    }#process

    END { }#end

}