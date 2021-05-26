get_district_cases <- function(){
  
  # Navigate to knoema website
  remDr$navigate("https://knoema.com/yxhrvz/covid-19-cases-by-districts-in-india")
  Sys.sleep(10)
  
  # Reading HTML script and pointing to head of data table
  district_data_table <- xml2::read_html(remDr$getPageSource()[[1]])
  district_data_table <- selectr::querySelector(district_data_table, "div.ranking-members")
  
  # Getting districts 
  districts <- selectr::querySelectorAll(district_data_table, "div.member-holder div.member-name")
  districts <- purrr::map_chr(districts, xml2::xml_text)
  
  # Getting cases
  cases <- selectr::querySelectorAll(district_data_table, "div.member-holder div.member-value")
  cases <- purrr::map_chr(cases, xml2::xml_text)
  cases <- gsub("\\,", "", cases)
  cases <- gsub(".00$","", cases)
  
  # Tidy
  #tidy districts
  districts <- tidyr::as_tibble(districts)
  districts <- dplyr::rename(districts, district = "value")
  
  #tidy cases
  cases <- tidyr::as_tibble(cases)
  cases <- dplyr::mutate(cases, value = as.numeric(value))
  cases <- dplyr::rename(cases, cases = "value")
  
  # Combine data
  out <- dplyr::bind_cols(districts, cases)
  
  # return output
  return(out)
}