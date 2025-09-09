

# Spotify Advanced SQL Project 
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/najirh/najirh-Spotify-Data-Analysis-using-SQL/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
DROP TABLE IF EXISTS spotify.song;
CREATE TABLE spotify.song (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 4. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.
  
---
## 14 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
2. List all albums along with their respective artists.
3. Get the total number of comments for tracks where `licensed = TRUE`.
4. Find all tracks that belong to the album type `single`.
5. Count the total number of tracks by each artist.

### Medium Level
1. Calculate the average danceability of tracks in each album.
2. Find the top 5 tracks with the highest energy values.
3. List all tracks along with their views and likes where `official_video = TRUE`.
4. For each album, calculate the total views of all associated tracks.
5. Retrieve the track names that have been streamed on Spotify more than YouTube.

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.
2. Write a query to find tracks where the liveness score is above the average.
3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
4. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
---
### 14 Practice Questions

### Easy Level
```sql
-- Q1: Retrieve tracks with more than 1 billion streams
SELECT track, artist, stream
FROM spotify.song
WHERE stream > 1000000000;

-- Q2: List all albums along with their respective artists
SELECT DISTINCT artist, album
FROM spotify.song
ORDER BY artist, album;

-- Q3: Total number of comments for licensed tracks
SELECT SUM(comments) AS total_comments
FROM spotify.song
WHERE licensed = TRUE;

-- Q4: Find all tracks that belong to the album type 'single'
SELECT track, artist, album
FROM spotify.song
WHERE album_type = 'single';

-- Q5: Count the total number of tracks by each artist
SELECT artist, COUNT(*) AS total_tracks
FROM spotify.song
GROUP BY artist
ORDER BY total_tracks DESC;
```
### Medium Level
```sql
-- Q6: Calculate the average danceability of tracks in each album
SELECT album, ROUND(AVG(danceability), 2) AS avg_danceability
FROM spotify.song
GROUP BY album
ORDER BY avg_danceability DESC;

-- Q7: Find the top 5 tracks with the highest energy
SELECT track, artist, energy
FROM spotify.song
ORDER BY energy DESC
LIMIT 5;

-- Q8: List all tracks with their views and likes where official_video = TRUE
SELECT track, SUM(views) AS total_views, SUM(likes) AS total_likes
FROM spotify.song
WHERE official_video = TRUE
GROUP BY track
ORDER BY total_views DESC;

-- Q9: Total views per album
SELECT album, SUM(views) AS total_views
FROM spotify.song
GROUP BY album
ORDER BY total_views DESC;

-- Q10: Tracks streamed more on Spotify than YouTube
WITH streamed AS (
    SELECT track,
           COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS spotify_stream,
           COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS youtube_stream
    FROM spotify.song
    GROUP BY track
)
SELECT track, spotify_stream, youtube_stream
FROM streamed
WHERE spotify_stream > youtube_stream
  AND youtube_stream <> 0;
```
### Advanced Level
```sql
-- Q11: Top 3 most-viewed tracks for each artist using window functions
SELECT *
FROM (
    SELECT artist, track, SUM(views) AS total_views,
           RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotify.song
    GROUP BY artist, track
) AS ranked
WHERE rank <= 3;

-- Q12: Tracks where liveness score is above average
SELECT track, artist, liveness
FROM spotify.song
WHERE liveness > (SELECT AVG(liveness) FROM spotify.song);

-- Q13: Difference between highest and lowest energy per album
WITH energy_diff AS (
    SELECT album, MAX(energy) AS max_energy, MIN(energy) AS min_energy
    FROM spotify.song
    GROUP BY album
)
SELECT album, max_energy, min_energy, max_energy - min_energy AS energy_range
FROM energy_diff
ORDER BY energy_range DESC;

-- Q14: Cumulative sum of likes ordered by views
WITH likes_summary AS (
    SELECT track, SUM(likes) AS total_likes, SUM(views) AS total_views
    FROM spotify.song
    GROUP BY track
)
SELECT track, total_likes,
       SUM(total_likes) OVER(ORDER BY total_views DESC) AS cumulative_likes
FROM likes_summary;
```


