declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "xml";
declare option output:indent "yes";

declare variable $error as xs:integer external;
let $congress_info := doc("congress_info.xml")/api-root/congress
let $members_list := doc("congress_members_info.xml")/api-root/members/member
let $error_list := doc("errors.xml")

let $congress_number := normalize-space($congress_info/number)
let $congress_name := normalize-space($congress_info/name)
let $congress_url := normalize-space($congress_info/url)
let $start_year := normalize-space($congress_info/startYear)
let $end_year := normalize-space($congress_info/endYear)

return
if ($error ne 0) then
  <data>
    <error>{$error_list/errors/error[@code=$error]/text()}</error>
  </data>
else
  <data>
    <congress>
      <name number="{$congress_number}"> {$congress_name} </name>
      <period from="{$start_year}" to="{$end_year}">
        From {$start_year} to {$end_year}
      </period>
      <url>{$congress_url}</url>
      <chambers>
      {
        for $chamber in distinct-values($congress_info//chamber)
          let $normalized_chamber := normalize-space($chamber)
          return
            <chamber>
              <name>{$normalized_chamber}</name>
              <members>
              {
                for $member in $members_list where some $member_chamber in $member//chamber satisfies normalize-space($member_chamber) = $normalized_chamber
                    let $name := normalize-space($member/name)
                    let $state := normalize-space($member/state)
                    let $party := normalize-space($member/partyName)
                    let $bioguideId := normalize-space($member/bioguideId)
                    let $image_url := normalize-space($member/depiction/imageUrl)
                    for $term in $member/terms/item/item where normalize-space($term/chamber) = $normalized_chamber
                    let $start_year := normalize-space($term/startYear)
                    let $end_year := normalize-space($term/endYear)
                    order by $name
                    return
                      <member bioguideId="{$bioguideId}">
                        <name>{$name}</name>
                        <state>{$state}</state>
                        <party>{$party}</party>
                        <image_url>{$image_url}</image_url>
                        {
                          if (not($end_year)) then
                            <period>From {$start_year}</period>
                          else
                            <period>From {$start_year} to {$end_year}</period>
                        }
                      </member>
              }
              </members>
              <sessions>
              {
                for $session in $congress_info/sessions/item[normalize-space(chamber) = $normalized_chamber]
                  let $number := normalize-space($session/number)
                  let $type := normalize-space($session/type)
                  let $start_date := normalize-space($session/startDate)
                  let $end_date := normalize-space($session/endDate)
                  order by $number
                  return
                    <session>
                      <number>{$number}</number>
                      <period from="{$start_date}" to="{$end_date}">
                        From {$start_date} to {$end_date}
                      </period>
                      <type>{$type}</type>
                    </session>
              }
              </sessions>
            </chamber>
      }
      </chambers>
    </congress>
  </data>