-- create table
DROP TABLE IF EXISTS SPOTIFY;

CREATE TABLE SPOTIFY (
	ARTIST VARCHAR(255),
	TRACK VARCHAR(255),
	ALBUM VARCHAR(255),
	ALBUM_TYPE VARCHAR(50),
	DANCEABILITY FLOAT,
	ENERGY FLOAT,
	LOUDNESS FLOAT,
	SPEECHINESS FLOAT,
	ACOUSTICNESS FLOAT,
	INSTRUMENTALNESS FLOAT,
	LIVENESS FLOAT,
	VALENCE FLOAT,
	TEMPO FLOAT,
	DURATION_MIN FLOAT,
	TITLE VARCHAR(255),
	CHANNEL VARCHAR(255),
	VIEWS FLOAT,
	LIKES BIGINT,
	COMMENTS BIGINT,
	LICENSED BOOLEAN,
	OFFICIAL_VIDEO BOOLEAN,
	STREAM BIGINT,
	ENERGY_LIVENESS FLOAT,
	MOST_PLAYED_ON VARCHAR(50)
);

-- EDA
SELECT
	*
FROM
	SPOTIFY;

-- number of rows
SELECT
	COUNT(*)
FROM
	SPOTIFY;

-- count the number of artist in the dataset
SELECT
	COUNT(DISTINCT ARTIST)
FROM
	SPOTIFY;

-- types of album types
SELECT DISTINCT
	ALBUM_TYPE
FROM
	SPOTIFY;

-- how many unique albums are present in the dataset
SELECT
	COUNT(DISTINCT ALBUM)
FROM
	SPOTIFY;

-- Problem 1: Retrieve the names of all tracks that have more than 1 billion streams.
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	STREAM >= 1000000000;

-- Problem 2: List all albums along with their respective artists.
SELECT DISTINCT
	ALBUM,
	ARTIST
FROM
	SPOTIFY;

-- Problem 2: List all albums with more than 2 artists.
SELECT
	ALBUM,
	COUNT(DISTINCT ARTIST)
FROM
	SPOTIFY
GROUP BY
	ALBUM
HAVING
	COUNT(DISTINCT ARTIST) >= 2
	-- Problem 3: Get the total number of comments for tracks where licensed = TRUE.
SELECT
	SUM(COMMENTS) AS COMMENTS_COUNT
FROM
	SPOTIFY
WHERE
	LICENSED = 'true';

-- Problem 4: Find all tracks that belong to the album type single.
SELECT
	TRACK
FROM
	SPOTIFY
WHERE
	ALBUM_TYPE = 'single'
	-- Problem 5: Count the total number of tracks by each artist.
SELECT
	ARTIST,
	COUNT(*) AS TOTAL_NO_TRACKS
FROM
	SPOTIFY
GROUP BY
	1
ORDER BY
	2 DESC
	-- Problem 6: Calculate the average danceability of tracks in each album.
SELECT
	ALBUM,
	AVG(DANCEABILITY) AS AVG_DANCEABILITY
FROM
	SPOTIFY
GROUP BY
	1
ORDER BY
	2 DESC;

-- Problem 7:Find the top 5 tracks with the highest energy values.
SELECT
	TRACK,
	AVG(ENERGY)
FROM
	SPOTIFY
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	5
	-- Problem 8: List all tracks along with their views and likes where official_video = TRUE.
SELECT
	TRACK,
	SUM(VIEWS),
	SUM(LIKES)
FROM
	SPOTIFY
WHERE
	OFFICIAL_VIDEO = TRUE
GROUP BY
	1
ORDER BY
	2 DESC
	-- Problem 9: For each album, calculate the total views of all associated tracks.
SELECT
	ALBUM,
	TRACK,
	SUM(VIEWS) AS TOTAL_VIEWS
FROM
	SPOTIFY
GROUP BY
	1,
	2
ORDER BY
	3 DESC
	
	-- Problem 10: Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT
	*
FROM
	(SELECT TRACK,
		COALESCE(SUM(CASE
						WHEN MOST_PLAYED_ON = 'Youtube' THEN STREAM
					END
				),0) AS STREAM_YOUTUBE,
		COALESCE(SUM(
					CASE
						WHEN MOST_PLAYED_ON = 'Spotify' THEN STREAM
					END
				),
				0
			) AS STREAM_SPOTIFY
		FROM
			SPOTIFY
		GROUP BY
			1
	) AS STREAM_DETAILS
WHERE
	STREAM_SPOTIFY > STREAM_YOUTUBE
	AND STREAM_YOUTUBE <> 0



	-- Problem 11: Find the top 3 most-viewed tracks for each artist using window functions.






	-- Problem 12: Write a query to find tracks where the liveness score is above the average.
	-- Problem 13: Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
	-- Problem 14: Find tracks where the energy-to-liveness ratio is greater than 1.2.
	-- Problem 15: Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.