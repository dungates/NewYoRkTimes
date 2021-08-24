#' @title Solve the Spelling Bee Challenge
#'
#' @param bee_letters the list of letters to use
#' @param middle_letter the middle letter which must always be included
#'
#' @return a list of solutions in descending order of word length
#' @examples nyt_solve(letters = "iloveyo", middle_letter = "o")
#' @importFrom magrittr %>%
#' @export

nyt_solve <- function(bee_letters, middle_letter) {

  # data("words")

  words <- readr::read_rds(here::here("Data/words.rds"))

  names <- readr::read_rds(file = here::here("Data/names.rds")) %>%
    purrr::as_vector() %>%
    paste0(collapse = "|")

  bee_letters <- stringr::str_split(bee_letters, pattern = "") %>%
    purrr::as_vector()

  not_bee_letters <- letters %>%
    tibble::as_tibble() %>%
    dplyr::anti_join(bee_letters %>% tibble::as_tibble()) %>%
    purrr::as_vector() %>%
    paste0(collapse = "|")

  dictionary <- tibble::tibble(words) %>%
    dplyr::rename(word = 1) %>%
    # Filter for at least 4 bee_letters
    dplyr::filter(stringr::str_length(word) >= 4) %>%
    # Filter for center letter
    dplyr::filter(stringr::str_detect(word, middle_letter)) %>%
    # Filter out other bee_letters
    dplyr::filter(!stringr::str_detect(word, not_bee_letters)) %>%
    # Filter out names
    dplyr::filter(!stringr::str_detect(word, names)) %>%
    # No apostrophes
    dplyr::filter(!stringr::str_detect(word, "'")) %>%
    # No duplicates
    dplyr::distinct(word, .keep_all = T)

  answers <- dictionary %>%
    # Start letter count column
    dplyr::mutate(letter_count = 0) %>%
    dplyr::rowwise() %>%
    dplyr::mutate(letter_count = sum(stringr::str_detect(word, bee_letters))) %>%
    dplyr::mutate(panagram = dplyr::if_else(sum(stringr::str_detect(word, bee_letters)) >= 7,
                                            T,
                                            F)) %>%
    # Arrange descending
    dplyr::arrange(desc(panagram), desc(letter_count))

  answers %>%
    reactable::reactable(theme = reactablefmtr::fivethirtyeight(),
                         columns = list(
                          letter_count = reactable::colDef(align = "center", maxWidth = 130,
                                              cell = reactablefmtr::color_tiles(.,
                                                                                colors = rev(nationalparkcolors::park_palette("Yellowstone", 3))))))
}
