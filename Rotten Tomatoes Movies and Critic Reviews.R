 library(tidyverse)

# Load Data: Import the data using read.csv() and inspect it using summary().

movies <- read_csv("C:\\Users\\zisan\\Downloads\\Exploratory projects\\Rotten-Tomatoes-Movie-Analysis\\data\\movies.csv")

head(movies)

summary(movies)

colnames(movies)

# Check if there are any missing values in each column
missing_values <- colSums(is.na(movies))
print(missing_values)

# Count total missing values in the entire dataset
total_missing <- sum(is.na(movies))
print(total_missing)

# Remove rows with missing data
clean_movies <- na.omit(movies)

# Check the structure of the dataset, including data types
str(movies)

# Convert multiple columns to Date type
movies$original_release_date <- as.Date(movies$original_release_date, format = "%Y-%m-%d")
movies$streaming_release_date <- as.Date(movies$streaming_release_date, format = "%Y-%m-%d")

# using dplyr for a more programmatic approach if there are many date columns:

library(dplyr)

movies <- movies %>%
  mutate(across(starts_with("date"), as.Date, format = "%Y-%m-%d"))

# Top Genres: Use dplyr to find the top genres by average tomatometer_rating.

top_genres <- movies %>%
  group_by (genres) %>%
  summarize(avg_tomatometer_rating = mean (tomatometer_rating, na.rm = TRUE)) %>%
  arrange(desc (avg_tomatometer_rating))

head(top_genres, 7)

# Boxplot: Create a boxplot of audience_rating by genre.

ggplot(movies, aes(x = genres, y=audience_rating)) + geom_boxplot() +
xlab("Genres") + 
  ylab("Audience Rating") + 
  ggtitle("Boxplot of Audience Rating by Genre") 


# Correlation Matrix: Calculate the correlation between audience_rating, runtime, and tomatometer_rating.

correlation <- cor(movies$audience_rating, movies$runtime)
print(correlation)

correlation <- cor(movies$audience_rating, movies$tomatometer_rating)
print(correlation)

correlation <- cor(movies$tomatometer_rating, movies$runtime)
print(correlation)

# Runtime Analysis: Create a histogram of runtime.

ggplot(movies, aes(x = runtime)) + 
         geom_histogram(bins = 15)
       
# Movie Popularity: Plot a bar chart of movies with the highest audience_count.

top_movies <- movies %>%
  filter(!is.na(audience_count)) %>%
  arrange(desc(audience_count)) %>%
  slice(1:10)

print(top_movies)

ggplot(top_movies, aes(x = movie_title, y= audience_count)) +geom_col()

# Plot a scatter plot showing the relationship between runtime and tomatometer_rating.

plot (
  movies$runtime,
  movies$tomatometer_rating,
  xlab = "Runtime Minute",
  ylab = "Tomatometer_rating",
  main = "Runtime vs Tomatometer_rating",
  pch = 18,
  col = "blue"
)
