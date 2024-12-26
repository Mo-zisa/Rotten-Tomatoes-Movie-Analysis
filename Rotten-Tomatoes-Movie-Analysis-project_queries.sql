-- Basic Query: List all movies with tomatometer_rating greater than 80.

select movie_title, directors, tomatometer_rating
    from movies
where cast(tomatometer_rating as numeric) > 80
order by tomatometer_rating desc
limit 5;

Rear Window,Alfred Hitchcock,99
20 Feet From Stardom,Morgan Neville,99
Casablanca,Michael Curtiz,99
All About Eve,Joseph L. Mankiewicz,99
56 Up,"Michael Apted, Paul Almond",99


-- Critic Count: Count the total number of reviews per critic.

select c2 as critic_name, count(*) as total_reviews
from critic_reviews
group by c2
order by total_reviews desc
limit 5;

no data,17203
Emanuel Levy,7662
Dennis Schwartz,6076
Roger Ebert,5966
Brian Orndorf,5624


-- Genre Count: Count how many movies belong to each genre.

select genres, count(*) as movie_by_genre
from movies
group by genres
order by movie_by_genre desc
limit 5;

Drama,1887
Comedy,1263
"Comedy, Drama",863
"Drama, Mystery & Suspense",731
"Art House & International, Drama",589

-- Top 5 Directors: Find the top 5 directors with the highest average tomatometer_rating.

select directors,
       count(*) as movie_count,
       avg(cast(tomatometer_rating as numeric)) as avg_tomatometer_rating
from movies
where directors IN(
    select directors
    from movies
    group by directors
    order by count(*) desc
    limit 5
    )
group by directors
order by avg_tomatometer_rating desc;

Alfred Hitchcock,36,87.25
Clint Eastwood,38,70.7631578947368421
Woody Allen,36,70.1388888888888889
Sidney Lumet,31,67.2258064516129032
no data,194,65.845360824742268


-- Highly Rated Movies: List all movies with both audience_rating and tomatometer_rating above 90.

select movie_title,
        cast(audience_rating as numeric) as aud_above_90,
       cast(tomatometer_rating as numeric) as tom_above_90
from movies
where cast(audience_rating as numeric) > 90 and
    cast(tomatometer_rating as numeric) > 90
order by aud_above_90 desc, tom_above_90 desc
limit 5;

Foosballers,100,100
Charm City,100,100
Anthony Jeselnik: Thoughts and Prayers,100,100
Canary (Kanarie),100,100
I Will Make You Mine,100,100

-- Yearly Releases: Count the number of movies released each year.

SET datestyle = "MDY";

select
    extract(year from original_release_date::DATE) as release_year,
    count(*) as total_count
from movies
group by release_year
order by total_count desc
limit 10

1442,1166
2014,745
2013,704
2012,669
2015,650

--Fresh Reviews: Query all reviews labeled as “Fresh.”

select
    movie_title, tomatometer_status,
    count(*) as total_count
from movies
where tomatometer_status = 'Fresh'
group by movie_title, tomatometer_status;


-- Most Reviewed Critics: Identify the critic who has written the most reviews.

select
    c2 as critic_name,
    count(*) as total_count
from critic_reviews
group by c2
order by total_count desc
limit 5;

no data,17203
Emanuel Levy,7662
Dennis Schwartz,6076
Roger Ebert,5966
Brian Orndorf,5624


-- Audience vs Critics: Calculate the average rating difference between audience_rating and tomatometer_rating grouped by genre.

select
    genres,
    avg(cast(audience_rating as numeric)) as avg_aud_rating,
    avg(cast(tomatometer_rating as numeric)) as avg_tom_rating,
    avg(cast(audience_rating as numeric) - cast(tomatometer_rating as numeric)) as avg_rat_diff
from movies
where genres is not null
group by genres
order by avg_rat_diff;

"Comedy, Musical & Performing Arts, Sports & Fitness",0,100,-100
"Action & Adventure, Television",0,86,-86
"Documentary, Romance",0,76,-76
"Animation, Art House & International, Horror",37,100,-63
"Action & Adventure, Art House & International, Cult Movies, Drama",30,88,-58

-- Review Distribution: Find the percentage of reviews that are “Fresh” vs “Rotten.” ((((((((((((()))))))))))))

select
    tomatometer_status,
    (count(*)* 100.0 / (select count(*) from movies)) as percentage
from movies
where tomatometer_status in ('Fresh', 'Rotten')
group by tomatometer_status
order by percentage desc;

Rotten,42.711156278229449
Fresh,38.6404697380307136


-- Genre Ratings: Find the average tomatometer_rating for each genre.

select
    genres,
    avg(cast(tomatometer_rating as numeric)) as avg_tom_ratting
from movies
group by genres
order by avg_tom_ratting desc
limit 5;

"Documentary, Gay & Lesbian, Sports & Fitness",100
"Art House & International, Classics, Comedy, Drama, Mystery & Suspense",100
"Classics, Comedy, Drama, Kids & Family, Romance",100
"Classics, Documentary, Drama, Western",100
"Animation, Classics, Comedy, Kids & Family, Musical & Performing Arts, Television",100


-- Streaming Trends: List the most common production companies releasing streaming movies.

select production_company,
       count(*) as total_pro_count
from movies
group by production_company
order by total_pro_count desc
limit 5;

Paramount Pictures,517
Warner Bros. Pictures,509
no data,499
Universal Pictures,495
20th Century Fox,423


--Director Genres: List all directors and the genres of movies they’ve directed.

select
    directors,
    genres,
    count(*) as total_count
from movies
group by directors, genres
order by total_count desc
limit 10 offset 4;

Spike Lee,Drama,11
no data,"Documentary, Special Interest",10
Barry Levinson,Drama,9
Errol Morris,"Documentary, Special Interest",8
Alfred Hitchcock,"Classics, Drama, Mystery & Suspense",8


-- Top Movie: Find the movie with the highest difference between tomatometer_top_critics_count and tomatometer_rotten_critics_count.

select
    movie_title,
    cast(tomatometer_top_critics_count as numeric) as tom_cr_count,
    cast(tomatometer_rotten_critics_count as numeric) as rott_count,
    cast(tomatometer_top_critics_count as numeric) - cast(tomatometer_rotten_critics_count as numeric) as diff_count
from movies
        order by diff_count desc
        limit 5;

Finding Nemo,61,2,59
Boyhood,69,10,59
Selma,61,4,57
Get Out,63,7,56
Moonlight,63,7,56


Top Publishers: Identify publishers with the most number of reviews.

select
    c2 as critic_name,
    count(*) as total_count
from critic_reviews
group by c2
order by total_count desc
limit 5;


New York Times,12378
Variety,10811
Time Out,10526
eFilmCritic.com,9568
Los Angeles Times,9386
