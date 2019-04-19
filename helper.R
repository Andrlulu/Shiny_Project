to_date_with_fmt <- function(date_str, fmt){
  as.Date(date_str, format = fmt)
}

get_date <- function(date_str){
  if( grepl("^\\d{1,2}\\b/\\d{1,2}\\b/\\d{4}\\b", date_str[1]) ){
    return(to_date_with_fmt(date_str, "%m/%d/%Y"))
  } else if ( grepl("^\\d{1,2}\\b/\\d{1,2}\\b/\\d{2}\\b", date_str[1]) ){
    return(to_date_with_fmt(date_str, "%m/%d/%y"))
  } else if( grepl("^\\d{1,2}\\b-\\d{1,2}\\b-\\d{4}\\b", date_str[1]) ){
    return(to_date_with_fmt(date_str, "%m-%d-%Y"))
  } else if ( grepl("^\\d{1,2}\\b-\\d{1,2}\\b-\\d{2}\\b", date_str[1]) ){
    return(to_date_with_fmt(date_str, "%m-%d-%y"))
  } else if( grepl("^\\d{4}\\b-\\d{1,2}\\b-\\d{1,2}\\b", date_str[1]) ){
    return(to_date_with_fmt(date_str, "%Y-%m-%d"))
  }
}

remove_empty_date <- function(date_str){
  date_str = trimws(date_str)
  return(ifelse(date_str=="", NA, date_str))
}