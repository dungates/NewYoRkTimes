#' ---
#' output: reprex::reprex_document
#' ---

#' @title Solve the Spelling Bee Challenge
#'
#' @param letters the list of letters to use
#' @param middle_letter the middle letter which must always be included
#'
#' @return a list of solutions in descending order of word length
#' @examples nyt_solve(letters = "iloveyo", middle_letter = "o")
#' @importFrom magrittr %>%
#' @export

nyt_solve <- function(letters, middle_letter) {

  # data("words")

  words <- readr::read_rds(here::here("Data/words.rds"))

  names <- readr::read_rds(file = here::here("Data/names.rds")) %>%
    purrr::as_vector() %>%
    paste0(collapse = "|")

  letters <- stringr::str_split(letters, pattern = "") %>%
    purrr::as_vector()

  not_letters <- (LETTERS %>% stringr::str_to_lower()) %>%
    tibble::as_tibble() %>%
    dplyr::filter(!(value %in% letters)) %>%
    purrr::as_vector() %>%
    paste0(collapse = "|")

  dictionary <- tibble::tibble(word = words)

  answers <- dictionary %>%
    # Make all dictionary words lowercase
    dplyr::mutate(word = tolower(word)) %>%
    # Start letter count column
    dplyr::mutate(letter_count = 0) %>%
    # Count each letter in one column
    dplyr::mutate(letter_count = dplyr::case_when(
      stringr::str_detect(word, letters[1]) == T ~ letter_count + stringr::str_count(word, letters[1]),
      stringr::str_detect(word, letters[1]) == F ~ letter_count
    )) %>%
    dplyr::mutate(letter_count = dplyr::case_when(
      stringr::str_detect(word, letters[2]) == T ~ letter_count + stringr::str_count(word, letters[2]),
      stringr::str_detect(word, letters[2]) == F ~ letter_count
    )) %>%
    dplyr::mutate(letter_count = dplyr::case_when(
      stringr::str_detect(word, letters[3]) == T ~ letter_count + stringr::str_count(word, letters[3]),
      stringr::str_detect(word, letters[3]) == F ~ letter_count
    )) %>%
    dplyr::mutate(letter_count = dplyr::case_when(
      stringr::str_detect(word, letters[4]) == T ~ letter_count + stringr::str_count(word, letters[4]),
      stringr::str_detect(word, letters[4]) == F ~ letter_count
    )) %>%
    dplyr::mutate(letter_count = dplyr::case_when(
      stringr::str_detect(word, letters[5]) == T ~ letter_count + stringr::str_count(word, letters[5]),
      stringr::str_detect(word, letters[5]) == F ~ letter_count
    )) %>%
    dplyr::mutate(letter_count = dplyr::case_when(
      stringr::str_detect(word, letters[6]) == T ~ letter_count + stringr::str_count(word, letters[6]),
      stringr::str_detect(word, letters[6]) == F ~ letter_count
    )) %>%
    dplyr::mutate(letter_count = dplyr::case_when(
      stringr::str_detect(word, letters[7]) == T ~ letter_count + stringr::str_count(word, letters[7]),
      stringr::str_detect(word, letters[7]) == F ~ letter_count
    )) %>%
    # Filter out other letters
    dplyr::filter(!stringr::str_detect(word, not_letters)) %>%
    # Filter out names
    # filter(!stringr::str_detect(word, names)) %>%
    # Filter for center letter
    dplyr::filter(stringr::str_detect(word, middle_letter)) %>%
    # Filter for at least 4 letters
    dplyr::filter(letter_count >= 4) %>%
    # No apostrophes
    dplyr::filter(!stringr::str_detect(word, "'")) %>%
    # No duplicates
    dplyr::distinct(word, .keep_all = T) %>%
    # Arrange descending
    dplyr::arrange(desc(letter_count))

  # Need to filter out names

  answers
}
