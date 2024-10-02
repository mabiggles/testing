$patterns = @{
    'MM/DD/YYYY' = '\b(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[01])/(19|20)\d{2}\b'
    'DD/MM/YYYY' = '\b(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[0-2])/(19|20)\d{2}\b'
    'YYYY-MM-DD' = '\b(19|20)\d{2}-(0?[1-9]|1[0-2])-(0?[1-9]|[12][0-9]|3[01])\b'
    'Month DD, YYYY' = '\b(January|February|March|April|May|June|July|August|September|October|November|December) (0?[1-9]|[12][0-9]|3[01]),? (19|20)\d{2}\b'
    'DD Month YYYY' = '\b(0?[1-9]|[12][0-9]|3[01]) (January|February|March|April|May|June|July|August|September|October|November|December) (19|20)\d{2}\b'
}




function Convert-DateToUnifiedFormat {
    param (
        [string]$dateString
    )
    try {
        # Attempt to parse and convert the date
        $date = [datetime]::ParseExact($dateString, 'MM/dd/yyyy', $null)
        return $date.ToString('MM/dd/yyyy HH:mm:ss')
    } catch {
        # Handle different formats
        if ($dateString -match '^(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[01])/(19|20)\d{2}$') {
            return [datetime]::ParseExact($dateString, 'MM/dd/yyyy', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '^(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[0-2])/(19|20)\d{2}$') {
            return [datetime]::ParseExact($dateString, 'dd/MM/yyyy', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '^(19|20)\d{2}-(0?[1-9]|1[0-2])-(0?[1-9]|[12][0-9]|3[01])$') {
            return [datetime]::ParseExact($dateString, 'yyyy-MM-dd', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '^(January|February|March|April|May|June|July|August|September|October|November|December) (0?[1-9]|[12][0-9]|3[01]),? (19|20)\d{2}$') {
            return [datetime]::ParseExact($dateString, 'MMMM dd, yyyy', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '^(0?[1-9]|[12][0-9]|3[01]) (January|February|March|April|May|June|July|August|September|October|November|December) (19|20)\d{2}$') {
            return [datetime]::ParseExact($dateString, 'dd MMMM yyyy', $null).ToString('MM/dd/yyyy HH:mm:ss')
        }
    }
    return $null
}
