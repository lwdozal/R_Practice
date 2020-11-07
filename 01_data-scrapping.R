# 01_data scraping in ml-sentiment analysis workshop 
# 11/7/2020


#install the packages you need
install.packages('tidytext')
install.packages('tidyverse')
install.packages('rvest') #package to download and extract data from the websites
install.packages(('RTools'))

#Once the packages are installed you can call them from the library
#call libraries
library(tidyverse)
library(rvest)


#https://www.amazon.com/BIC-Cristal-1-0mm-Black-MSLP16-Blk/product-reviews/B004F9QBE6
# chosen amazon review page
# this one has the page number
url <- "https://www.amazon.com/AmazonBasics-Pre-sharpened-Wood-Cased-Pencils/product-reviews/B071JM699B/ref=cm_cr_getr_d_paging_btm_prev_1?ie=UTF8&reviewerType=all_reviews&pageNumber=1"

#read in html page and assign it to object called amazon_reviews
amazon_reviews <- read_html(url)

#get nodes for review texts ('.review-text-content') - will help identify the class
review_text <- amazon_reviews %>%
  html_nodes(".review-text-content") %>% #extracts exact nodes
  html_text()

review_text

#get nodes for rating (".a-icon-alt")
review_ratings <- amazon_reviews %>% 
  html_nodes(".a-icon-alt") %>% 
  html_text() %>% 
  tail(10)
review_ratings


#build data frame that holds two variables: text and rate
pencil_reviews <- data.frame(text = review_text,
                            rate = review_ratings)

#make sure you check that the dataset matches the web content




############################ Data Cleaning #############################

#read full data file with 2K reviews
pencil_reviews <- read_csv("pencil_reviews.csv")

#look at the text of pencil reviews
pencil_reviews %>% 
  pull(text) %>% 
  head(1)

#remove linebreaks (\n)
pencil_reviews <- pencil_reviews %>% 
  mutate(text = gsub("\\n", "", text)) %>% #gsub = global substitution, looks for a pattern and changes it to something else
  mutate(text = trimws(text)) #trimws trims the white space

#look at line 16
pencil_reviews[16,]

#replace "out of 5 stars" with noting
pencil_reviews <- pencil_reviews %>% 
  mutate(rate = sub(" out of 5 stars", "", rate))
#view(pencil_reviews)
