--Q.1 Retrieve the names of all tracks that have more than 1 billion streams.
select
	*
from
	spotify.song s
where
	s.stream > 1000000000
;
--Q.2 List all albums along with their respective artists.
select
	distinct
s.artist ,
	s.album
from
	spotify.song s 
;
--Q.3 Get the total number of comments for tracks where licensed = TRUE.
select
	sum(comments) as total_comments
from
	spotify.song s
where
	s.licensed = 'true'
;
--Q.4 Find all tracks that belong to the album type single.
select
	*
from
	spotify.song s
where
	s.album_type = 'single'
;
--Q.5 Count the total number of tracks by each artist.
select
	s.artist,
	count(*) as total_on_song
from
	spotify.song s
group by
	1
order by
	2 desc 
;
--Q.6 Calculate the average danceability of tracks in each album.
select
	s.album,
	avg(s.danceability) as avg_danceability
from
	spotify.song s
group by
	1
order by
	2 desc
;
--Q.7 Find the top 5 tracks with the highest energy values.
select
	s.track,
	s.energy
from
	spotify.song s
order by
	2 desc
limit 5 
;
--Q.8 List all tracks along with their views and likes where official_video = TRUE.
select
	s.track,
	sum(views) as total_views,
	sum(likes) as total_likes
from
	spotify.song s
where
	s.official_video = true
group by
	1
;
--Q.9 For each album, calculate the total views of all associated tracks.
select
	s.album,
	sum(views) as total_views
from
	spotify.song s
group by
	s.album
order by
	2 desc
;
--Q.10 Retrieve the track names that have been streamed on Spotify more than YouTube.
with streamed as (
select
	s.track,
	s.stream,
	coalesce (sum(case when s.most_playedon = 'Spotify' then s.stream end),
	0) as streamed_Spotify,
	coalesce(sum(case when s.most_playedon = 'Youtube' then s.stream end), 0) as streamed_youtube
from
	spotify.song s
group by
	1,2
)
select
	track,
	streamed_Spotify,
	streamed_youtube
from
	streamed
where
	streamed_Spotify > streamed_youtube
	and streamed_youtube <> 0
;
--Q.11 Find the top 3 most-viewed tracks for each artist using window functions.
select
	*
from
	(
	select
		s.artist,
		s.track ,
		sum(s.views) as total_views,
		rank() over(partition by s.artist order by sum(s.views) desc) as ranking
	from
		spotify.song s
	group by
		1,
		2
	order by
		1,
		3 desc) as ct
where
	ranking <= 3
;
--Q.12 Write a query to find tracks where the liveness score is above the average.
select
	*
from
	spotify.song s
where
	s.liveness > (
	select
		avg(liveness)
	from
		spotify.song)
;
--Q.13 Use a WITH clause to calculate the difference between 
--     the highest and lowest energy values for tracks in each album.
with difference as (
select
	s.album,
	max(s.energy) as highest_energy,
	min(s.energy) as lowest_energy
from
	spotify.song s
group by
	1)
select
	*,
	highest_energy - lowest_energy as diff_energy
from
	difference
;
--Q.14 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
with cumulative_likes as (
select
	s.track,
	sum(likes) as total_likes,
	sum(views) as total_views
from
	spotify.song s
group by
	1
      )

select
	track,
	total_likes,
	sum(total_likes) over(order by total_views desc) as Running_likes
from
	cumulative_likes
;
