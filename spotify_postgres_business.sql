-- Advanced SQL Project -- Spotify Datasets

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
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


-- EDA

SELECT
	COUNT(*) FROM spotify;

SELECT
	COUNT(DISTINCT(artist)) FROM spotify;

SELECT DISTINCT(album_type) FROM spotify;

SELECT MAX(duration_min) FROM spotify;
SELECT MIN(duration_min) FROM spotify;

SELECT * FROM spotify
WHERE duration_min = 0

DELETE FROM spotify
WHERE duration_min = 0

SELECT DISTINCT channel FROM spotify;

SELECT
	most_played_on FROM spotify;
-----------------------------------
-- Data Analysis -Easy Category
-----------------------------------

Easy Level


Retrieve the names of all tracks that have more than 1 billion streams.

SELECT
	track,
	stream
	FROM spotify
	WHERE stream >= 1000000000
	GROUP BY 1,2;


List all albums along with their respective artists.

SELECT
	DISTINCT album,
	artist
FROM spotify;



Get the total number of comments for tracks where licensed = TRUE.

SELECT
	SUM(comments)
	FROM spotify
	WHERE licensed = 'true';

Find all tracks that belong to the album type single.

SELECT
	track
	FROM spotify
	WHERE album_type ILIKE '%single%';

Count the total number of tracks by each artist.

SELECT
	COUNT(*) as total_no_songs,
	artist
FROM spotify
GROUP BY artist
ORDER BY 1 DESC;



Medium Level
Calculate the average danceability of tracks in each album.

SELECT
	AVG(danceability) as avg_danceability,
	album
	FROM spotify
	GROUP BY 2
	ORDER BY 1 DESC;

Find the top 5 tracks with the highest energy values.

SELECT
	track,
	AVG(energy)
	FROM spotify
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 5;

List all tracks along with their views and likes where official_video = TRUE.

SELECT
	track,
	SUM(views) as total_views,
	SUM(likes) as total_likes
FROM
(SELECT
	*
	FROM spotify
	WHERE official_video = 'true') as offical_video_true
	GROUP BY 1;


For each album, calculate the total views of all associated tracks.

SELECT
	album,
	track,
	SUM(views)
	FROM spotify
	GROUP BY 1,2;

Retrieve the track names that have been streamed on Spotify more than YouTube.


SELECT
	*
	FROM
(SELECT
	track,
	--most_played_on,
		COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) as streamed_youtube,
		COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END),0) as stream_spotify
	FROM spotify
	GROUP BY 1
	) as most_played_count
	WHERE streamed_youtube < stream_spotify
	AND streamed_youtube != 0;



Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking AS 
(SELECT
	track,
	artist,
	SUM(views) as total_view,
	dense_rank() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) as rank_artist
	FROM spotify
	GROUP BY 1, artist, views
	ORDER BY 1,3 DESC
) 

SELECT
	*
	FROM ranking
	WHERE rank_artist >= 3;



	


Write a query to find tracks where the liveness score is above the average.

SELECT
	track,
	liveness
	FROM spotify
	GROUP BY 1,2
	HAVING liveness > (SELECT AVG(liveness) FROM spotify)

Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

WITH difference AS (
	SELECT
		album,
		(MAX(energy) - MIN(energy)) as difference_energy
	FROM spotify
	GROUP BY 1
	ORDER BY 2 DESC

)

SELECT
	*
	FROM difference

