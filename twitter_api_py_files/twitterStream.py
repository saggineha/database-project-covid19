import sys, requests, os
import requests_oauthlib, json
import tweepy
import math
import glob
import csv
import zipfile
import zlib
import argparse
import os.path as osp
import pandas as pd
from pandas.conftest import compression
from time import sleep



# retrieve tweets in time range by tweepy api
# limited 100 tweets per request same as twitter API
def tweepy_result(api):
    public_tweets = api.home_timeline()
    result = api.search_full_archive(environment_name='data225', query='', fromDate='20190111201',
                                     toDate='201901121201', maxResults=10)
    for line in result:
        all_tweet = json.loads(line)
        print(line)
        all_tweet = json.loads(line)
        print(json.dumps(all_tweet, indent=4, sort_keys=True))
    print(type(result))
    return result


# retrieve tweets by twitter id using tweepy API
# convert to csv
def tweetId_to_csv_result(api):

    if api.verify_credentials() == False:
        print("Your twitter api credentials are invalid")
        sys.exit()
    else:
        print("Your twitter api credentials are valid.")

    inputfile_data = pd.read_csv('date-tweet-id.tsv')
    print('tab seperated file, using \\t delimiter')
    print(inputfile_data)
    inputfile_data = inputfile_data.set_index('tweet_id')
    ids = list(inputfile_data.index)
    print('total ids: {}'.format(len(ids)))
    start = 0
    end = 100
    limit = len(ids)
    i = int(math.ceil(float(limit) / 100))
    last_tweet = None

    if osp.isfile(args.outputfile) and osp.getsize(args.outputfile) > 0:
        with open(output_file, 'rb') as f:
            # may be a large file, seeking without iterating
            f.seek(-2, os.SEEK_END)
            while f.read(1) != b'\n':
                f.seek(-2, os.SEEK_CUR)
            last_line = f.readline().decode()
        last_tweet = json.loads(last_line)
        start = ids.index(last_tweet['id'])
        end = start + 100
        i = int(math.ceil(float(limit - start) / 100))

    print('metadata collection complete')
    print('creating master json file')
    try:
        with open(output_file, 'a') as outfile:
            for go in range(i):
                print('currently getting {} - {}'.format(start, end))
                sleep(6)  # needed to prevent hitting API rate limit
                id_batch = ids[start:end]
                start += 100
                end += 100
                backOffCounter = 1
                while True:
                    try:
                        if hydration_mode == "e":
                            tweets = api.statuses_lookup(id_batch, tweet_mode="extended")
                        else:
                            tweets = api.statuses_lookup(id_batch)
                        break
                    except tweepy.TweepError as ex:
                        print('Caught the TweepError exception:\n %s' % ex)
                        sleep(30 * backOffCounter)  # sleep a bit to see if connection Error is resolved before retrying
                        backOffCounter += 1  # increase backoff
                        continue
                for tweet in tweets:
                    json.dump(tweet._json, outfile)
                    outfile.write('\n')
    except:
        print('exception: continuing to zip the file')

    print('creating ziped master json file')
    zf = zipfile.ZipFile('{}.zip'.format(output_file_noformat), mode='w')
    zf.write(output_file, compress_type=compression)
    zf.close()

    def is_retweet(entry):
        return 'retweeted_status' in entry.keys()

    def get_source(entry):
        if '<' in entry["source"]:
            return entry["source"].split('>')[1].split('<')[0]
        else:
            return entry["source"]

    print('creating minimized json master file')
    with open(output_file_short, 'w') as outfile:
        with open(output_file) as json_data:
            for tweet in json_data:
                data = json.loads(tweet)
                if hydration_mode == "e":
                    text = data["full_text"]
                else:
                    text = data["text"]
                t = {
                    "created_at": data["created_at"],
                    "text": text,
                    "in_reply_to_screen_name": data["in_reply_to_screen_name"],
                    "retweet_count": data["retweet_count"],
                    "favorite_count": data["favorite_count"],
                    "source": get_source(data),
                    "id_str": data["id_str"],
                    "is_retweet": is_retweet(data)
                }
                json.dump(t, outfile)
                outfile.write('\n')

    f = csv.writer(open('{}.csv'.format(output_file_noformat), 'w'))
    print('creating CSV version of minimized json master file')
    fields = ["favorite_count", "source", "text", "in_reply_to_screen_name", "is_retweet", "created_at",
              "retweet_count", "id_str"]
    f.writerow(fields)
    with open(output_file_short) as master_file:
        for tweet in master_file:
            data = json.loads(tweet)
            f.writerow(
                [data["favorite_count"], data["source"], data["text"].encode('utf-8'), data["in_reply_to_screen_name"],
                 data["is_retweet"], data["created_at"], data["retweet_count"], data["id_str"].encode('utf-8')])

# catch the real time data stream from Twitter API
def streamTweets(twitter_auth):
    url = 'https://stream.twitter.com/1.1/statuses/filter.json'
    # query_data
    stream_param = [('language', 'en'), ('locations', '-90,-20,100,50'), ('track', '#')]
    stream_url = url + '?' + '&'.join([str(t[0]) + '=' + str(t[1]) for t in stream_param])
    resp = requests.get(stream_url, auth=twitter_auth, stream=True)
    print(stream_url, resp)
    for line in resp.iter_lines():
        all_tweet = json.loads(line)
        print(json.dumps(all_tweet, indent=4, sort_keys=True))
        tweet_pure_text = all_tweet['text'] + '\n'  # pyspark can't accept stream, add '\n'
        print("Tweet pure text is : " + tweet_pure_text)
        tag = all_tweet['entities']['hashtags']
        if tag:
            all_tag = [t['text'] for t in tag]
            print(all_tag)
    return resp

# Search tweets by specific query keyword using Twitter API
# limited 100 tweets per request and recent 7 days data
def searchTweets(twitter_auth, query):
    url = 'https://api.twitter.com/1.1/search/tweets.json'
    search_param = [('q', query), ('count', '100'), ('result_type', 'popular'), ('country_code', 'US')]
    search_url = url + '?' + '&'.join([str(t[0]) + '=' + str(t[1]) for t in search_param])
    resp = requests.get(search_url, auth=twitter_auth, stream=True)
    print(search_url, resp)
    for line in resp.iter_lines():
        all_tweet = json.loads(line)
        print(json.dumps(all_tweet, indent=4, sort_keys=True))
        print(len(all_tweet['statuses']))
    return all_tweet
# Twitter API V2 search API same result as method searchTweets
# def search(headers):
#     url = 'https://api.twitter.com/2/tweets/search/all'
#     # search_param = [('start_time', '2019-03-01:12:00:01'), ('country_code', 'US'), ('count', '1')]
#     search_param = {'query': 'covid', 'country_code': 'US', 'count': '1'}
#     search_url = url + '?' + '&'.join([str(t[0]) + '=' + str(t[1]) for t in search_param])
#     resp = requests.get(search_url, auth=headers, stream=True)
#     # resp = connect_to_endpoint(search_url, headers, search_param)
#     print(search_url, resp)
#     for line in resp.iter_lines():
#         all_tweet = json.loads(line)
#         print(json.dumps(all_tweet, indent=4, sort_keys=True))
#     return all_tweet

def create_headers(bearer_token):
    headers = {"Authorization": "Bearer {}".format(bearer_token)}
    return headers


def connect_to_endpoint(url, headers, params):
    response = requests.request("GET", url, headers=headers, params=params)
    print(response.status_code)
    if response.status_code != 200:
        raise Exception(response.status_code, response.text)
    return response.json()

def main():
    ACCESS_TOKEN = "Your Access Token"
    ACCESS_SECRET = "Your Access Secret"
    CONSUMER_KEY = "Your Consumer Key"
    CONSUMER_SECRET = "Your Consumer Secret"
    twitter_auth = requests_oauthlib.OAuth1(CONSUMER_KEY, CONSUMER_SECRET, ACCESS_TOKEN, ACCESS_SECRET)
    bearer_token = 'The bearer_Token'
    headers = create_headers(bearer_token)
    all_stream_Tweets = streamTweets(twitter_auth)
    all_search_tweets = searchTweets(twitter_auth, 'covid')
    # search(twitter_auth)
    auth = tweepy.OAuthHandler(CONSUMER_KEY, CONSUMER_SECRET)
    auth.set_access_token(ACCESS_TOKEN, ACCESS_SECRET)
    api = tweepy.API(auth, wait_on_rate_limit=True, retry_delay=60 * 3, retry_count=5,
                     retry_errors=set([401, 404, 500, 503]), wait_on_rate_limit_notify=True)




if __name__ == "__main__":
    main()