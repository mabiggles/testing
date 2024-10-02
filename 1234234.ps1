$patterns = @{
    'MM/DD/YYYY'        = '\b(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[01])/(19|20)\d{2}(\s+\d{2}:\d{2}:\d{2})?\b'
    'DD/MM/YYYY'        = '\b(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[0-2])/(19|20)\d{2}(\s+\d{2}:\d{2}:\d{2})?\b'
    'YYYY-MM-DD'        = '\b(19|20)\d{2}-(0?[1-9]|1[0-2])-(0?[1-9]|[12][0-9]|3[01])(\s+\d{2}:\d{2}:\d{2})?\b'
    'Month DD, YYYY'    = '\b(January|February|March|April|May|June|July|August|September|October|November|December) (0?[1-9]|[12][0-9]|3[01]),? (19|20)\d{2}(\s+\d{2}:\d{2}:\d{2})?\b'
    'DD Month YYYY'     = '\b(0?[1-9]|[12][0-9]|3[01]) (January|February|March|April|May|June|July|August|September|October|November|December) (19|20)\d{2}(\s+\d{2}:\d{2}:\d{2})?\b'
    'Bracketed Date'    = '\[(19|20)\d{2}-(January|February|March|April|May|June|July|August|September|October|November|December)-(0?[1-9]|[12][0-9]|3[01]) (\d{2}:\d{2}:\d{2})\]'
}




function Convert-DateToUnifiedFormat {
    param (
        [string]$dateString
    )
    try {
        if ($dateString -match '^\[(\d{4})-(\w+)-(\d{1,2}) (\d{2}:\d{2}:\d{2})\]$') {
            # Extract components for bracketed date
            $year = $matches[1]
            $month = $matches[2]
            $day = $matches[3]
            $time = $matches[4]
            return [datetime]::ParseExact("$year $month $day $time", 'yyyy MMMM d HH:mm:ss', $null).ToString('MM/dd/yyyy HH:mm:ss')
        }

        # Handle date formats without time
        if ($dateString -match '(\d{2}/\d{2}/\d{4})') {
            return [datetime]::ParseExact($dateString, 'MM/dd/yyyy', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '(\d{2}/\d{2}/\d{4})') {
            return [datetime]::ParseExact($dateString, 'dd/MM/yyyy', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '(\d{4}-\d{2}-\d{2})') {
            return [datetime]::ParseExact($dateString, 'yyyy-MM-dd', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '((January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2},? \d{4})') {
            return [datetime]::ParseExact($dateString, 'MMMM dd, yyyy', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '((\d{1,2}) (January|February|March|April|May|June|July|August|September|October|November|December) \d{4})') {
            return [datetime]::ParseExact($dateString, 'dd MMMM yyyy', $null).ToString('MM/dd/yyyy HH:mm:ss')
        }

        # Handle date formats with time
        if ($dateString -match '(\d{2}/\d{2}/\d{4}) (\d{2}:\d{2}:\d{2})') {
            return [datetime]::ParseExact($dateString, 'MM/dd/yyyy HH:mm:ss', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '(\d{2}/\d{2}/\d{4}) (\d{2}:\d{2}:\d{2})') {
            return [datetime]::ParseExact($dateString, 'dd/MM/yyyy HH:mm:ss', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '(\d{4}-\d{2}-\d{2}) (\d{2}:\d{2}:\d{2})') {
            return [datetime]::ParseExact($dateString, 'yyyy-MM-dd HH:mm:ss', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '((January|February|March|April|May|June|July|August|September|October|November|December) \d{1,2},? \d{4} (\d{2}:\d{2}:\d{2}))') {
            return [datetime]::ParseExact($dateString, 'MMMM dd, yyyy HH:mm:ss', $null).ToString('MM/dd/yyyy HH:mm:ss')
        } elseif ($dateString -match '((\d{1,2}) (January|February|March|April|May|June|July|August|September|October|November|December) \d{4} (\d{2}:\d{2}:\d{2}))') {
            return [datetime]::ParseExact($dateString, 'dd MMMM yyyy HH:mm:ss', $null).ToString('MM/dd/yyyy HH:mm:ss')
        }
    } catch {
        # Handle any parsing errors
        return $null
    }
    return $null
}
