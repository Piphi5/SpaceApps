import urllib3
import requests
import pprint as pp
import random

api_key = '7WouR3LvkOHw6Cn2rtqfsQ6hfwLyXKekqtuA22hZ'

def apod():
    URL = "https://api.nasa.gov/planetary/apod"
    params = {
        'api_key': api_key,
        'hd': 'True'
    }
    response = requests.get(URL, params=params).json()
    imgLink = response['hdurl']
    print(imgLink)

def imgapi(y):
    pageNum = 1#random.randint(1, 51)
    URL = "https://images-api.nasa.gov/search?description=" + str(y) + "&media_type=image&page=" + str(pageNum)
    response = requests.get(URL).json()
    #pp.pprint(response)

    collection = response['collection']
    allItems = collection['items']
    itemNum = random.randint(0, len(allItems)-1)
    item = allItems[itemNum]
    allitemlinks = item['links']
    imageLink = allitemlinks[0]['href']
    #print(imageLink)
    return imageLink

# apod()
if __name__ == '__main__':
    y = input("What image would you like to get: ")
    print(imgapi(y))


'''
Scrap Code:


	if(x == 1):
		print("One")
	elif(x == 2):
		print("Two")
	elif (x == 3):
		print("Three")
	elif (x == 4):
		print("Four")
	elif (x == 5):
		print("Five")
	elif(x == 6):
		print("Six")
		

'''