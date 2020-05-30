from bs4 import BeautifulSoup
import urllib.request

def search_nasa(keywords):
    links = []
    url = "https://nasasearch.nasa.gov/search?utf8=%E2%9C%93&affiliate=nasa&sort_by=&query="
    source = urllib.request.urlopen((url + keywords).replace(" ", "+")).read()
    soup = BeautifulSoup(source, "html.parser")
    articles = soup.find_all('h4', {"class" : "title"})
    for article in articles:
        links.append(article.find('a')['href'])
    return links