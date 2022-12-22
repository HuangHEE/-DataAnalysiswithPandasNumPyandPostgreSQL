select * from users;
select * from photos;
select * from likes;
select * from comments;
select * from follows;
select * from tags;
select * from photo_tags;

/*We want to reward our users who have been around the longest.  
Find the 5 oldest users.*/
SELECT * FROM users
ORDER BY created_at
LIMIT 5;

select * from users
/*What day of the week do most users register on?
We need to figure out when to schedule an ad campgain*/
select EXTRACT (dow from created_at ) AS "Day of week", COUNT(*) 
FROM users
GROUP BY 1
ORDER BY 2 DESC;

/*version 2*/
SELECT to_char(created_at, 'DAY') AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;

SELECT to_char(created_at, 'day') AS day,
    COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC;


/*We want to target our inactive users with an email campaign.
Find the users who have never posted a photo*/
SELECT username
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE photos.id IS NULL;


/*Our Investors want to know...
How many times does the average user post?*/
/*total number of photos/total number of users*/
SELECT ROUND((SELECT COUNT(*)FROM photos)/(SELECT COUNT(*) FROM users),2);


/*user ranking by postings higher to lower*/
SELECT users.username,COUNT(photos.image_url)
FROM users
JOIN photos ON users.id = photos.user_id
GROUP BY users.id
ORDER BY 2 DESC;


/*Total Posts by users (longer versionof SELECT COUNT(*)FROM photos) */
SELECT SUM(user_posts.total_posts_per_user)
FROM (SELECT users.username,COUNT(photos.image_url) AS total_posts_per_user
		FROM users
		JOIN photos ON users.id = photos.user_id
		GROUP BY users.id) AS user_posts;


/*total numbers of users who have posted at least one time */
SELECT COUNT(DISTINCT(users.id)) AS total_number_of_users_with_posts
FROM users
JOIN photos ON users.id = photos.user_id;


/*We also have a problem with celebrities
Find users who have never commented on a photo*/
SELECT username, comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id,comment_text
HAVING comment_text IS NULL;

select * from users;
select * from comments;


-- number of people who never commented on any post
select count(*) from
(select username, comment_text
	from users
	left join comments on users.id = comments.user_id
	group by users.id, comments.comment_text
	having comment_text is null) 
as total_number_of_users_without_comments;


/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/
SELECT tag_name, COUNT(tag_name) AS total
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.id
ORDER BY total DESC;

--count tags_name
select tag_name,
count(tag_name) As total
from tags
join photo_tags on tags.id = photo_tags.tag_id
group by tags.id
order by total desc;

select tag_name,
count(tag_name) As total
from tags
join photo_tags on tags.id = photo_tags.tag_id
group by tags.id
order by total desc
limit 5;


/*Find users who have ever commented on a photo*/
SELECT username,comment_text
FROM users
LEFT JOIN comments ON users.id = comments.user_id
GROUP BY users.id,comment_text
HAVING comment_text IS NOT NULL;


SELECT COUNT(*) FROM
(SELECT username,comment_text
	FROM users
	LEFT JOIN comments ON users.id = comments.user_id
	GROUP BY users.id,comment_text
	HAVING comment_text IS NOT NULL) AS total_number_users_with_comments;

