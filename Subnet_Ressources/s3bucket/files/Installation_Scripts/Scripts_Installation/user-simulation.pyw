#!python3
import datetime
import time
import webbrowser
import os
import random
import subprocess
from ldap3 import Server, Connection, ALL
from subprocess import call
import sys
import logging
from logging.handlers import RotatingFileHandler
import string

def is_within_range(start_hour, start_minute, end_hour, end_minute):
    now = datetime.datetime.now().time()
    start_time = datetime.time(start_hour, start_minute)
    end_time = datetime.time(end_hour, end_minute)

    if start_time <= now <= end_time:
        return True
    else:
        return False

def connect_ad_login(domain_user, AdminPD,ad_server):
    try:
        # Establish connection to Active Directory server
        server = Server(ad_server, get_info=ALL)
        conn = Connection(server, user=domain_user, password=AdminPD, auto_bind=True)
        # Retrieve information about the authenticated user
        whoami = conn.extend.standard.who_am_i()
        # Log successful connection
        logging.info(f"Successfully connected to Active Directory server {ad_server} as user {domain_user}.")
        # Log information about the authenticated user (whoami)
        logging.info(f"Authenticated user: {domain_user}")
        # Close the connection
        conn.unbind()
        return domain_user
    except Exception as e:
        # Log any exceptions that occur during the connection attempt
        logging.info(f"Failed to connect to Active Directory server {ad_server} as user {domain_user}: {e}")
        return None

def random_browser(url_to_open,domain_user):
    browsers = [
        "edge",
        "firefox"
    ]
    chosen_browser = random.choice(browsers)
    
    if chosen_browser == "edge":
        webbrowser.open(url_to_open)
    elif chosen_browser == "firefox":
        subprocess.run([r"C:\Program Files\\Mozilla Firefox\\firefox.exe", url_to_open])
    elif chosen_browser == "chrome":
        subprocess.run([r"C:\Program Files\\Google\\Chrome\\Application\\chrome.exe", url_to_open])
    return chosen_browser

def get_available_drives():
    drives = []
    for drive in range(ord('A'), ord('Z') + 1):
        drive_letter = chr(drive) + ":\\"
        if os.path.exists(drive_letter):
            drives.append(drive_letter)
    return drives

def open_program(program):
    process = subprocess.Popen(program)
    return process.pid

def close_program(pid, program_name):
    try:
        # Use tasklist command to get a list of processes and their PIDs
        output = subprocess.check_output(["tasklist", "/fo", "csv", "/nh"]).decode()
        found_pid = False
        for line in output.splitlines():
            parts = line.split(",")
            if int(parts[1].strip('"')) == pid and program_name.lower() in parts[0].lower():
                # Use taskkill command to terminate the process
                subprocess.run(["taskkill", "/PID", str(pid), "/F"])
                logging.info(f"Closed Program with PID {pid}: {program_name}")
                found_pid = True
                break
        if not found_pid:
            logging.info(f"Process with PID {pid} is not {program_name}.")
            # Fall back to using program name
            close_program_by_name(program_name)
    except subprocess.CalledProcessError:
        logging.error("Error occurred while trying to close the program.")

def close_program_by_name(program_name):
    try:
        # Use tasklist command to get a list of processes
        output = subprocess.check_output(["tasklist", "/fo", "csv", "/nh"]).decode()
        for line in output.splitlines():
            parts = line.split(",")
            if program_name.lower() in parts[0].lower():
                pid = int(parts[1].strip('"'))
                # Use taskkill command to terminate the process
                subprocess.run(["taskkill", "/PID", str(pid), "/F"])
                logging.info(f"Closed Program: {program_name}")
    except subprocess.CalledProcessError:
        logging.error("Error occurred while trying to close the program.")

def open_urls(urls):
    for url in urls:
        webbrowser.open(url)

def drive_exists(drive_name):
    try:
        subprocess.run(['powershell', '-Command', f'Get-PSDrive -Name {drive_name}'], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        return True
    except subprocess.CalledProcessError:
        return False

def map_network_drive(drive_name, root_path, domain_user, AdminPD):
    if drive_exists(drive_name):
        logging.info(f"The drive {drive_name} already exists.")
    else:
        try:
            subprocess.run(['powershell', '-Command', f'New-PSDrive -Persist -Name "{drive_name}" -PSProvider "FileSystem" -Root "{root_path}" -Credential (New-Object System.Management.Automation.PSCredential("{domain_user}", (ConvertTo-SecureString "{AdminPD}" -AsPlainText -Force))) -Scope Global'], check=True, shell=True)
            logging.info(f"The drive {drive_name} has been mapped to {root_path}.")
        except subprocess.CalledProcessError as e:
            logging.info(f"Failed to map the drive {drive_name}: {e}")


def list_files_in_directory(directory):
    """
    List all files in a directory recursively.
    """
    file_list = []
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_list.append(os.path.join(root, file))
    return file_list

def filter_files_by_extension(files, extensions):
    """
    Filter files by extension.
    """
    filtered_files = []
    for file in files:
        if os.path.splitext(file)[1] in extensions:
            filtered_files.append(file)
    return filtered_files

def open_and_close_file(file_path, program):
    """
    Open the file with the specified program, wait 10 seconds, then close the program.
    """
    try:
        subprocess.Popen([program, file_path])
        time.sleep(10)
        subprocess.Popen(["taskkill", "/F", "/IM", os.path.basename(program)])
    except FileNotFoundError as e:
        logging.info(f"File not found: {file_path}. Skipping...")
        logging.info(f"Error : {e}")

def disconnect_psd_drive(server_address):
    """
    Disconnects PSDrives connected to the specified server address.
    """
    # Define the PowerShell command to disconnect PSDrives
    disconnect_command = f"Get-PSDrive | Where-Object {{ $_.DisplayRoot -like '\\\\{server_address}\\*' }} | ForEach-Object {{ Remove-PSDrive -Name $_.Name -Force }}"

    # Execute the PowerShell command
    try:
        subprocess.run(["powershell.exe", "-Command", disconnect_command], check=True)
        logging.info("PSDrives disconnected successfully.")
    except subprocess.CalledProcessError as e:
        logging.info(f"Error: {e}")

def list_directories_in_directory(directory):

    """
    List all directories in a directory.
    """
    directory_list = []
    for root, dirs, files in os.walk(directory):
        for dir in dirs:
            directory_list.append(os.path.join(root, dir))
    return directory_list

def create_text_file(file_path,file_name, content):
    try:
        with open(file_path+r'\\'+file_name, 'w') as file:
            file.write(content)
        logging.info(f"File created: {file_path}")
    except Exception as e:
        logging.info(f"Error creating file: {e}")

def read_text_file(random_directory, file_name):
    try:
        with open(random_directory+r'\\'+file_name, 'r') as file:
            content = file.read()
            logging.info(f"File content: {content}")
    except FileNotFoundError as e:
        logging.info(f"File not found: {random_directory}+r'\\'+{file_name}.")
    except Exception as e:
        logging.info(f"Error reading file: {e}")

def delete_file(random_directory, file_name):
    try:
        os.remove(random_directory+r'\\'+file_name)
        logging.info(f"File deleted: {random_directory}+r'\\'+{file_name}")
    except FileNotFoundError as e:
        logging.info(f"File not found: {random_directory}+r'\\'+{file_name}.")
    except Exception as e:
        logging.info(f"Error deleting file: {e}")

def generate_random_filename(length: int = 24, extension: str = "") -> str:
    """Generates a random filename"""
    characters = string.ascii_letters + string.digits
    random_string = "".join(random.choice(characters) for _ in range(length))
    if extension:
        if "." in extension:
            pieces = extension.split(".")
            last_extension = pieces[-1]
            extension = last_extension
        return f"{random_string}.{extension}"
    return random_string

def append_to_text_file(random_directory, file_name, additional_content):
    try:
        with open(random_directory + '\\' + file_name, 'a') as file:
            file.write(additional_content)
        logging.info("Content added successfully.")
    except FileNotFoundError as e:
        logging.info(f"File not found: {random_directory}\\{file_name}.")
    except Exception as e:
        logging.info(f"Error appending to file: {e}")

def main(url,extensions,urls_to_open_init,files_to_open_init,progs_to_open_init,programs,drive_mappings,morning_ad_login,afternoon_ad_login,domain,username,AdminPD,domain_user,ad_server):
    while True:
        current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        # Get LDAP info once between 8:30 and 9:30
        if is_within_range(8, 30, 9, 30) and morning_ad_login == False:
            logging.info(f"Sending Logging Event to AD for User : {domain_user}")
            connect_ad_login(domain_user, AdminPD,ad_server)
            morning_ad_login =True
        else:
            logging.debug(f"Not in Morning Login Time : {current_time} or already Authenticated.")
        # Get LDAP info once between 13:30 and 14:30
        if is_within_range(13, 30, 14, 30) and afternoon_ad_login == False:
            logging.info(f"Sending Logging Event to AD for User : {domain_user}")
            connect_ad_login(domain_user, AdminPD,ad_server)
            afternoon_ad_login =True
        else:
            logging.debug(f"Not in Afternoon Login Time : {current_time} or already Authenticated.")
        # Open some URLs until the end between 8:30 and 9:30
        while True:
            if is_within_range(8, 30, 18, 30):
                logging.info("Within the Workday / Worktime")
                logging.info("Opening URLs")
                num_urls_to_open = random.randint(min(1, len(url)),(len(url)))
                while urls_to_open_init <= num_urls_to_open:
                    url_to_open = random.choice(url)  # Replace with your desired URL
                    chosen_browser = random_browser(url_to_open,domain_user)
                    logging.info(f"Opening URL : {url_to_open} in Browser : {chosen_browser}")
                    time.sleep(random.randint(10,15))
                    logging.info(f"Cleaning URL : {url_to_open} in Browser : {chosen_browser}")
                    if chosen_browser == "edge":
                        webbrowser.open(url_to_open)
                    elif chosen_browser == "firefox":
                        os.system("taskkill /im firefox.exe /f")
                    elif chosen_browser == "chrome":
                        os.system("taskkill /im chrome.exe /f")
                    else:
                        os.system("taskkill /im msedge.exe /f")
                        os.system("taskkill /im firefox.exe /f")
                        os.system("taskkill /im chrome.exe /f")
                    time.sleep(random.randint(10,15))
                    urls_to_open_init += 1
                logging.info("Opening Files")
                num_files_to_open = random.randint(1,5)
                while files_to_open_init <= num_files_to_open:
                    available_drives = get_available_drives()
                    logging.info(f"Available Drives : {available_drives}")
                    for drive_mapping in drive_mappings:
                        drive_letter, root_path, domain_user, AdminPD = drive_mapping
                        map_network_drive(*drive_mapping)
                    all_files = []
                    for drive_letter, root_path, domain_user, AdminPD in drive_mappings:
                        files = list_files_in_directory(root_path)
                        all_files.extend(files)
                    filtered_files = filter_files_by_extension(all_files, extensions_to_program.keys())
                    # Select a random number of files between 1 and 50
                    num_files_to_select = random.randint(1, 50)
                    # Randomly select files
                    selected_files = random.sample(filtered_files, min(num_files_to_select, len(filtered_files)))
                    for file in selected_files:
                        extension = os.path.splitext(file)[1]
                        program = extensions_to_program[extension]
                        logging.info(f"File to Open : {file}")
                        open_and_close_file(file, program) 
                        time.sleep(random.randint(10,15))
                    time.sleep(random.randint(10,15))
                    files_to_open_init += 1
                logging.info("Creating Files")
                list_directories = []
                for drive_letter, root_path, domain_user, AdminPD in drive_mappings:
                    #logging.info(f"Drive: {drive_letter}")
                    directories = list_directories_in_directory(root_path)
                    if directories:
                        random_directory = random.choice(directories)
                        list_directories.append(random_directory)
                        #logging.info(f"Random Directory: {random_directory}")
                    else:
                        pass
                        #logging.info("No directories found.")
                random_directory = random.choice(list_directories)
                file_name = generate_random_filename()+'.txt'
                logging.info(f"Random Directory : {random_directory}")
                # Create text file
                create_text_file(random_directory, file_name, content)
                logging.info(f"File : {file_name}, created in Directory : {random_directory}")
                time.sleep(random.randint(10,15))
                # Read text file
                read_text_file(random_directory, file_name)
                time.sleep(random.randint(10,15))
                # Append content to the existing file
                additional_content = "Additional content appended."
                append_to_text_file(random_directory, file_name, additional_content)
                time.sleep(random.randint(10,15))
                # Read text file
                read_text_file(random_directory, file_name)
                time.sleep(random.randint(10,15))
                # # Delete text file
                delete_file(random_directory, file_name)
                time.sleep(random.randint(10,15))
                logging.info("Opening Programs")
                num_progs_to_open = random.randint(min(1, len(programs)), len(programs))
                program_pids = {}
                selected_programs = random.sample(programs, num_progs_to_open)
                logging.info("Starting Programs")
                for program in selected_programs:
                    logging.info(f"Starting Program: {program}" )
                    program_pids[program] = open_program(program)
                    time.sleep(random.randint(10,15))
                logging.info("Waiting for programs to open...")
                time.sleep(random.randint(10,15))
                for program, pid in program_pids.items():
                    logging.info(f"Closing Program: {program}" )
                    close_program(pid, os.path.basename(program))
                time.sleep(random.randint(10,15))
                progs_to_open_init += 1
                logging.info("Ending Programs")
                if not is_within_range(8, 30, 18, 30):
                    logging.DEBUG("Checking Within Range")
                    break  # Break out of the loop if the condition is no longer met
            else:
                pass
            if is_within_range(18, 31, 8, 29):
                logging.DEBUG(f"Out of Range, no actions : {current_time}")
                morning_ad_login = False
                afternoon_ad_login = False



url = ["paypal.com", "photobucket.com", "netvibes.com", "wunderground.com", "washingtonpost.com", "exblog.jp", "marriott.com", 
        "pcworld.com", "creativecommons.org", "bravesites.com", "imdb.com", "fc2.com", "sohu.com", "123-reg.co.uk", "constantcontact.com", 
        "ibm.com", "linkedin.com", "cocolog-nifty.com", "dedecms.com", "sun.com", "msu.edu", "topsy.com", "japanpost.jp", "livejournal.com", 
        "salon.com", "columbia.edu", "amazonaws.com", "163.com", "github.io", "thetimes.co.uk", "dailymotion.com", "ustream.tv", "phpbb.com", 
        "meetup.com", "sbwire.com", "howstuffworks.com", "4shared.com", "edublogs.org", "home.pl", "blogtalkradio.com", "slate.com", "businesswire.com", 
        "dagondesign.com", "github.com", "who.int", "csmonitor.com", "hexun.com", "cmu.edu", "google.com.au", "hostgator.com", "mapquest.com", "bigcartel.com", 
        "taobao.com", "gnu.org", "shutterfly.com", "ucoz.com", "skype.com", "tmall.com", "abc.net.au", "360.cn", "si.edu", "omniture.com", "intel.com", 
        "myspace.com", "usatoday.com", "lulu.com", "ed.gov", "pagesperso-orange.fr", "wix.com", "wordpress.com", "toplist.cz", "un.org", "seesaa.net", 
        "facebook.com", "jigsy.com", "reverbnation.com", "sphinn.com", "spotify.com", "homestead.com", "ow.ly", "yellowpages.com", "shinystat.com",
        "ameblo.jp", "nymag.com", "mediafire.com", "state.gov", "europa.eu", "google.de", "redcross.org", "addtoany.com", "virginia.edu", "prlog.org", 
        "cbslocal.com", "wordpress.org", "flavors.me", "walmart.com", "utexas.edu", "msn.com", "nationalgeographic.com", "eepurl.com", "java.com", 
        "live.com", "yandex.ru", "networkadvertising.org", "hud.gov", "histats.com", "desdev.cn", "chron.com", "drupal.org", "twitpic.com", "ucla.edu", 
        "oracle.com", "ifeng.com", "sciencedirect.com", "usgs.gov", "skyrock.com", "php.net", "foxnews.com", "uol.com.br", "springer.com", "house.gov", 
        "ycombinator.com", "soup.io", "nhs.uk", "seattletimes.com", "mapy.cz", "amazon.co.uk", "google.ru", "blog.com", "google.es", "yelp.com", "guardian.co.uk", 
        "macromedia.com", "wiley.com", "fema.gov", "liveinternet.ru", "networksolutions.com", "behance.net", "epa.gov", "theglobeandmail.com", "marketwatch.com", 
        "indiatimes.com", "usa.gov", "quantcast.com", "dell.com", "amazon.de", "google.pl", "squarespace.com", "miitbeian.gov.cn", "furl.net", "blinklist.com", 
        "symantec.com", "ted.com", "wikispaces.com", "tinyurl.com", "imgur.com", "ft.com", "mozilla.com", "engadget.com", "umn.edu", "mozilla.org", "goo.gl",
        "ning.com", "psu.edu", "chronoengine.com", "gravatar.com", "mlb.com", "last.fm", "bing.com", "fda.gov", "spiegel.de", "ftc.gov", "unc.edu", "disqus.com",
        "weather.com", "google.co.jp", "shareasale.com", "aboutads.info", "slashdot.org", "stumbleupon.com", "e-recht24.de", "time.com", "chicagotribune.com",
        "ox.ac.uk", "about.me", "army.mil", "ovh.net", "alexa.com", "techcrunch.com", "cafepress.com", "oakley.com", "vkontakte.ru", "telegraph.co.uk", "cisco.com",
        "nytimes.com", "diigo.com", "ezinearticles.com", "kickstarter.com", "plala.or.jp", "examiner.com", "parallels.com", "newyorker.com", "harvard.edu",
        "statcounter.com", "eventbrite.com", "ebay.co.uk", "samsung.com", "pinterest.com", "flickr.com", "oaic.gov.au", "zdnet.com", "senate.gov", "usnews.com",
        "comsenz.com", "reuters.com", "biblegateway.com", "storify.com", "blogspot.com", "accuweather.com", "merriam-webster.com", "yahoo.co.jp", "elegantthemes.com",
        "i2i.jp", "npr.org", "bloomberg.com", "bloglovin.com", "google.ca", "wired.com", "naver.com", "dropbox.com", "sfgate.com", "netlog.com", "multiply.com",
        "woothemes.com", "nba.com", "google.com.hk", "digg.com", "pbs.org", "theatlantic.com", "devhub.com", "sakura.ne.jp", "shop-pro.jp", "vimeo.com", "uiuc.edu",
        "t.co", "scientificamerican.com", "trellian.com", "nih.gov", "icq.com", "answers.com", "hao123.com", "indiegogo.com", "google.cn", "gizmodo.com",
        "washington.edu", "nydailynews.com", "goo.ne.jp", "forbes.com", "timesonline.co.uk", "cdc.gov", "ehow.com", "china.com.cn", "scribd.com", "huffingtonpost.com",
        "t-online.de", "phoca.cz", "tuttocitta.it", "ucsd.edu", "weibo.com", "a8.net", "surveymonkey.com", "themeforest.net", "upenn.edu", "go.com", "whitehouse.gov",
        "typepad.com", "feedburner.com", "w3.org", "issuu.com", "artisteer.com", "auda.org.au", "google.co.uk", "domainmarket.com", "smugmug.com", "freewebs.com",
        "dion.ne.jp", "nbcnews.com", "hugedomains.com", "moonfruit.com", "tumblr.com", "wisc.edu", "tripod.com", "deliciousdays.com", "hhs.gov", "blogs.com",
        "sogou.com", "infoseek.co.jp", "narod.ru", "tamu.edu", "mail.ru", "wufoo.com", "example.com", "gmpg.org", "nasa.gov", "elpais.com", "over-blog.com",
        "mac.com", "so-net.ne.jp", "independent.co.uk", "51.la", "state.tx.us", "wikia.com", "discuz.net", "bizjournals.com", "ca.gov", "zimbio.com", "reddit.com",
        "vistalogging.debug.com", "berkeley.edu", "godaddy.com", "technorati.com", "weebly.com", "mashable.com", "noaa.gov", "nifty.com", "tiny.cc", "irs.gov", "rakuten.co.jp",
        "princeton.edu", "bbb.org", "miibeian.gov.cn", "fotki.com", "va.gov", "randomlists.com", "sitemeter.com", "usda.gov", "newsvine.com", "vinaora.com", "mysql.com",
        "paginegialle.it", "jimdo.com", "nps.gov", "google.fr", "hatena.ne.jp", "sina.com.cn", "arstechnica.com", "ocn.ne.jp", "acquirethisname.com", "loc.gov", "twitter.com",
        "youtu.be", "latimes.com", "dot.gov", "cdbaby.com", "tinypic.com", "nature.com", "lycos.com", "com.com", "cargocollective.com", "webs.com", "free.fr", "nyu.edu", "angelfire.com",
        "economist.com", "sciencedaily.com", "simplemachines.org", "businessinsider.com", "yellowbook.com", "goodreads.com", "mayoclinic.com", "wikimedia.org", "google.it", "wp.com", "discovery.com",
        "logging.debugfriendly.com", "prweb.com", "booking.com", "about.com", "ebay.com", "census.gov", "cbc.ca", "de.vu", "smh.com.au", "prnewswire.com", "yolasite.com", "cnn.com", "hibu.com", "cbsnews.com",
        "cnet.com", "bluehost.com", "comcast.net", "posterous.com", "amazon.co.jp", "qq.com", "canalblog.com", "gov.uk", "youku.com", "xrea.com", "cyberchimps.com", "admin.ch", "dailymail.co.uk", "xing.com",
        "bloglines.com", "unicef.org", "cpanel.net", "youtube.com", "clickbank.net", "blogging.com", "jalbum.net", "dmoz.org", "odnoklassniki.ru", "cam.ac.uk", "unesco.org", "imageshack.us", "dyndns.org",
        "google.com", "webnode.com", "pen.io", "cnbc.com", "etsy.com", "g.co", "cornell.edu", "netscape.com", "unblog.fr", "umich.edu", "icio.us", "vk.com", "bandcamp.com", "opensource.org", "businessweek.com",
        "illinois.edu", "purevolume.com", "earthlink.net", "reference.com", "wikipedia.org", "ihg.com", "google.nl", "slideshare.net", "hc360.com", "friendfeed.com", "deviantart.com", "jugem.jp", "buzzfeed.com",
        "barnesandnoble.com", "is.gd", "xinhuanet.com", "adobe.com", "jiathis.com", "addthis.com", "soundcloud.com", "google.com.br", "1688.com", "joomla.org", "wsj.com", "mtv.com", "nsw.gov.au", "people.com.cn",
        "globo.com", "mit.edu", "aol.com", "stanford.edu", "arizona.edu", "geocities.com", "fastcompany.com", "ucoz.ru", "bbc.co.uk", "hubpages.com", "squidoo.com", "apache.org", "patch.com", "ask.com",
        "rambler.ru", "amazon.com", "webmd.com", "instagram.com", "yale.edu", "free13runpool.com", "studiopress.com", "apple.com", "cloudflare.com", "baidu.com", "biglobe.ne.jp", "1und1.de", "altervista.org",
        "opera.com", "boston.com", "webeden.co.uk", "privacy.gov.au", "list-manage.com", "microsoft.com", "yahoo.com", "sourceforge.net", "hp.com", "geocities.jp", "rediff.com", "craigslist.org", "delicious.com",
        "tripadvisor.com", "istockphoto.com", "theguardian.com", "archive.org", "alibaba.com", "nbcnews.com", "java.com", "list-manage.com", "dion.ne.jp", "php.net", "hp.com", "marriott.com", "usnews.com",
        "livejournal.com", "rediff.com", "sohu.com", "so-net.ne.jp", "spotify.com", "dyndns.org", "tmall.com", "va.gov", "bloglovin.com", "wired.com", "yahoo.com", "sogou.com", "ebay.com", "wikipedia.org",
        "blog.com", "dailymotion.com", "google.com.hk", "msn.com", "dmoz.org", "chronoengine.com", "kickstarter.com", "businessweek.com", "moonfruit.com", "cmu.edu", "t.co", "edublogs.org", "eepurl.com",
        "soup.io", "eventbrite.com", "usgs.gov", "washington.edu", "dot.gov", "theglobeandmail.com", "google.es", "netlog.com", "nasa.gov", "amazon.co.jp", "ft.com", "webs.com", "sciencedaily.com", "uiuc.edu",
        "wikispaces.com", "ask.com", "whitehouse.gov", "japanpost.jp", "deliciousdays.com", "buzzfeed.com", "harvard.edu", "storify.com", "opera.com", "slate.com", "patch.com", "state.tx.us", "prlog.org",
        "etsy.com", "smugmug.com", "biglobe.ne.jp", "github.com", "noaa.gov", "flavors.me", "mozilla.com", "a8.net", "discuz.net", "360.cn", "merriam-webster.com", "vk.com", "4shared.com", "hubpages.com",
        "dedecms.com", "ted.com", "mac.com", "businesswire.com", "about.com", "bbb.org", "mapquest.com", "instagram.com", "google.pl", "geocities.com", "liveinternet.ru", "webnode.com", "cnbc.com", "reddit.com",
        "oracle.com", "howstuffworks.com", "foxnews.com", "redcross.org", "qq.com", "gmpg.org", "booking.com", "wix.com", "jiathis.com", "chicagotribune.com", "ucoz.com", "myspace.com", "wufoo.com", "t-online.de",
        "lulu.com", "wordpress.org", "slideshare.net", "constantcontact.com", "creativecommons.org", "hugedomains.com", "bandcamp.com", "acquirethisname.com", "wp.com", "about.me", "quantcast.com", "hc360.com",
        "facebook.com", "skyrock.com", "w3.org", "deviantart.com", "tiny.cc", "jalbum.net", "tripod.com", "wordpress.com", "timesonline.co.uk", "tumblr.com", "symantec.com", "purevolume.com", "hao123.com",
        "huffingtonpost.com", "answers.com", "cam.ac.uk", "ed.gov", "alibaba.com", "is.gd", "nymag.com", "goodreads.com", "yelp.com", "pbs.org", "angelfire.com", "indiegogo.com", "census.gov", "prweb.com",
        "163.com", "prnewswire.com", "cbslocal.com", "artisteer.com", "fema.gov", "msu.edu", "hhs.gov", "bizjournals.com", "zimbio.com", "cbsnews.com", "nifty.com", "lycos.com", "slashdot.org",
        "networksolutions.com", "craigslist.org", "themeforest.net", "jigsy.com", "addtoany.com", "1688.com", "home.pl", "cornell.edu", "independent.co.uk", "rakuten.co.jp", "yandex.ru",
        "twitpic.com", "google.co.uk", "ning.com", "friendfeed.com", "nature.com", "paypal.com", "scribd.com", "soundcloud.com", "ibm.com", "trellian.com", "zdnet.com", "cbc.ca", "omniture.com",
        "i2i.jp", "homestead.com", "comsenz.com", "technorati.com", "comcast.net", "intel.com", "networkadvertising.org", "gnu.org", "infoseek.co.jp", "hud.gov", "studiopress.com", "cafepress.com",
        "google.ca", "barnesandnoble.com", "marketwatch.com", "nih.gov", "house.gov", "mysql.com", "issuu.com", "unicef.org", "over-blog.com", "sphinn.com", "last.fm", "theatlantic.com", "icio.us",
        "pcworld.com", "bluehost.com", "toplist.cz", "adobe.com", "time.com", "smh.com.au", "goo.gl", "weebly.com", "arstechnica.com", "economist.com", "g.co", "apache.org", "mashable.com", "typepad.com",
        "ebay.co.uk", "forbes.com", "google.de", "clickbank.net", "posterous.com", "dell.com", "umich.edu", "imageshack.us", "vinaora.com", "guardian.co.uk", "simplemachines.org", "usatoday.com",
        "chron.com", "miitbeian.gov.cn", "xrea.com", "amazon.de", "cyberchimps.com", "samsung.com", "google.cn", "china.com.cn", "arizona.edu", "baidu.com", "opensource.org", "shutterfly.com",
        "exblog.jp", "cisco.com", "elegantthemes.com", "si.edu", "sourceforge.net", "wsj.com", "bbc.co.uk", "privacy.gov.au", "nps.gov", "europa.eu", "ameblo.jp", "nationalgeographic.com",
        "salon.com", "mtv.com", "telegraph.co.uk", "com.com", "cnet.com", "theguardian.com", "xing.com", "google.ru", "narod.ru", "hostgator.com", "shareasale.com", "seesaa.net", "wiley.com",
        "ovh.net", "youtube.com", "globo.com", "nyu.edu", "elpais.com", "sbwire.com", "webeden.co.uk", "tuttocitta.it", "ezinearticles.com", "1und1.de", "mayoclinic.com", "domainmarket.com",
        "usa.gov", "shop-pro.jp", "go.com", "apple.com", "jugem.jp", "army.mil", "google.fr", "blogspot.com", "businessinsider.com", "examiner.com", "auda.org.au", "fc2.com", "randomlists.com",
        "amazonaws.com", "reference.com", "statcounter.com", "canalblog.com", "imgur.com", "wikia.com", "nsw.gov.au", "ftc.gov", "fastcompany.com", "wunderground.com", "yale.edu", "free13runpool.com",
        "usda.gov", "furl.net", "oaic.gov.au", "mit.edu", "stanford.edu", "goo.ne.jp", "amazon.co.uk", "who.int", "ustream.tv", "springer.com", "yolasite.com", "google.com.au", "google.co.jp", "youku.com",
        "engadget.com", "ifeng.com", "boston.com", "blinklist.com", "ucla.edu", "virginia.edu", "yahoo.co.jp", "netvibes.com", "webmd.com", "histats.com", "upenn.edu", "dailymail.co.uk", "weather.com",
        "ocn.ne.jp", "logging.debugfriendly.com", "blogtalkradio.com", "sciencedirect.com", "ucoz.ru", "weibo.com", "princeton.edu", "accuweather.com", "taobao.com", "dropbox.com", "mediafire.com", "digg.com",
        "ox.ac.uk", "people.com.cn", "oakley.com", "linkedin.com", "abc.net.au", "utexas.edu", "mlb.com", "yellowbook.com", "fda.gov", "alexa.com", "youtu.be", "miibeian.gov.cn", "washingtonpost.com",
        "newyorker.com", "earthlink.net", "squarespace.com", "ycombinator.com", "macromedia.com", "nhs.uk", "hatena.ne.jp", "spiegel.de", "nydailynews.com", "woothemes.com", "bloglines.com", "photobucket.com",
        "ucsd.edu", "archive.org", "parallels.com", "blogs.com", "123-reg.co.uk", "jimdo.com", "skype.com", "mapy.cz", "phoca.cz", "sakura.ne.jp", "yellowpages.com", "cloudflare.com", "thetimes.co.uk",
        "cargocollective.com", "amazon.com", "ehow.com", "paginegialle.it", "sina.com.cn", "senate.gov", "e-recht24.de", "pinterest.com", "ihg.com", "drupal.org", "naver.com", "godaddy.com", "aboutads.info",
        "vistalogging.debug.com", "bigcartel.com", "npr.org", "reuters.com", "columbia.edu", "fotki.com", "techcrunch.com", "unc.edu", "tripadvisor.com", "hexun.com", "wikimedia.org", "indiatimes.com", "twitter.com",
        "state.gov", "epa.gov", "ca.gov", "github.io", "altervista.org", "shinystat.com", "dagondesign.com", "imdb.com", "istockphoto.com", "pagesperso-orange.fr", "microsoft.com", "sun.com", "bing.com",
        "stumbleupon.com", "phpbb.com", "cdc.gov", "pen.io", "google.com.br", "odnoklassniki.ru", "disqus.com", "cocolog-nifty.com", "squidoo.com", "vimeo.com", "addthis.com", "free.fr", "google.it",
        "mozilla.org", "desdev.cn", "flickr.com", "live.com", "unblog.fr", "xinhuanet.com", "un.org", "cdbaby.com", "tamu.edu", "de.vu", "surveymonkey.com", "biblegateway.com", "scientificamerican.com",
        "joomla.org", "uol.com.br", "gravatar.com", "nytimes.com", "latimes.com", "cnn.com", "51.la", "meetup.com", "example.com", "gov.uk", "seattletimes.com", "loc.gov", "tinyurl.com", "wisc.edu", "behance.net",
        "discovery.com", "cpanel.net", "topsy.com", "unesco.org", "nba.com", "plala.or.jp", "reverbnation.com", "sfgate.com", "csmonitor.com", "diigo.com", "illinois.edu", "tinypic.com", "gizmodo.com", "irs.gov",
        "walmart.com", "hibu.com", "berkeley.edu", "multiply.com", "newsvine.com", "devhub.com", "delicious.com", "icq.com", "ow.ly", "aol.com", "bravesites.com", "psu.edu", "feedburner.com", "sitemeter.com",
        "blogging.com", "netscape.com", "freewebs.com", "rambler.ru", "google.com", "vkontakte.ru", "admin.ch", "mail.ru","10.0.10.103","10.0.20.103"]
programs = [
    r"C:\Program Files\qBittorrent\qbittorrent.exe",
    r"C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE",
    r"C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE",
    r"C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE",
    r"C:\Program Files\Microsoft Office\root\Office16\OUTLOOK.EXE",
    r"C:\Program Files (x86)\Steam\steam.exe",
    r"C:\Program Files (x86)\Dropbox\Client\Dropbox.exe",
    r"C:\Program Files (x86)\WinSCP\WinSCP.exe",
    r"C:\Program Files (x86)\Mobatek\MobaXterm\MobaXterm.exe",
    r"C:\Program Files (x86)\Glary Utilities\Integrator.exe",
    r"C:\Program Files\KeePass Password Safe 2\KeePass.exe",
    r"C:\Program Files\TeamViewer\TeamViewer.exe",
    r"C:\Program Files\Microsoft Office\root\Office16\lync.exe",
    r"C:\Program Files\Microsoft Office\root\Office16\MSPUB.EXE",
    r"C:\Program Files\TeamViewer\TeamViewer.exe",
    r"C:\Program Files\Mozilla Thunderbird\thunderbird.exe",
    r"C:\Program Files\Opera\opera.exe",
    r"C:\Program Files\Microsoft Office\root\Office16\ONENOTE.EXE",
    r"C:\Program Files\Microsoft OneDrive\OneDrive.exe",
    r"C:\Program Files\Notepad++\notepad++.exe",
    r"C:\Program Files\Google\Drive File Stream\90.0.3.0\GoogleDriveFS.exe",
    r"C:\Program Files\Microsoft Office\root\Office16\MSACCESS.EXE",
    r"C:\Program Files\Zoom\bin\Zoom.exe",
    r"C:\Program Files\WinRAR\WinRAR.exe",
    r"C:\Program Files\VideoLAN\VLC\vlc.exe",
    r"C:\Program Files\RealVNC\VNC Viewer\vncviewer.exe",
    r"C:\Program Files\PuTTY\putty.exe",
    r"C:\Program Files\iTunes\iTunes.exe",
    r"C:\Program Files (x86)\Foxit Software\Foxit PDF Reader\FoxitPDFReader.exe",
    r"C:\Program Files\FileZilla FTP Client\filezilla.exe",
    r"C:\Program Files\7-Zip\7zFM.exe"
]
extensions_to_program = {
    '.txt': r'C:\Windows\System32\notepad.exe',
    '.pdf': r'C:\Program Files (x86)\Foxit Software\Foxit PDF Reader\FoxitPDFReader.exe',
    '.docx': r'C:\Program Files\Microsoft Office\root\Office16\WINWORD.EXE',
    '.png': r'C:\Program Files\WindowsApps\Microsoft.Windows.Photos_21.606.10022.0_x64__8wekyb3d8bbwe\Microsoft.Photos.exe',
    '.pptx': r'C:\Program Files\Microsoft Office\root\Office16\POWERPNT.EXE',
    '.xls': r'C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE',
    '.xlsx': r'C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE',
    '.mp3': r'C:\Program Files\VideoLAN\VLC\vlc.exe',
    '.wav': r'C:\Program Files\VideoLAN\VLC\vlc.exe'
    # Add more extensions and programs as needed
}
content = "This is a sample text file. It contains some text for demonstration purposes. "
domain = sys.argv[1]
username = sys.argv[2]
AdminPD = sys.argv[3]
ad_server = sys.argv[4]
SiteName = sys.argv[5]
if SiteName == "IT":
    fileserver_ip = "10.0.10.102"
elif SiteName == "HQ":
    fileserver_ip = "10.0.20.102"
else:
    fileserver_ip = "10.0.10.102"
domain_user = f'{domain}\\{username}'
extensions = ['.pdf']
urls_to_open_init = 0
files_to_open_init = 0
progs_to_open_init = 0
morning_ad_login = False
afternoon_ad_login = False
log_file = r"C:\Users\Public\simulation.log"
file_handler = RotatingFileHandler(log_file, maxBytes=100*1024*1024, backupCount=1)
formatter = logging.Formatter("%(asctime)s - %(levelname)s - %(message)s")
file_handler.setFormatter(formatter)
file_handler.setLevel(logging.INFO)
logging.getLogger().addHandler(file_handler)
logging.getLogger().setLevel(logging.INFO)
disconnect_psd_drive("10.0.20.102")
disconnect_psd_drive("10.0.10.102")
drive_mappings = [
    ('G', f'\\\\{fileserver_ip}\\Share_Accounting', f'{domain_user}', f'{AdminPD}'),
    ('H', f'\\\\{fileserver_ip}\\Share_Administrative', f'{domain_user}', f'{AdminPD}'),
    ('I', f'\\\\{fileserver_ip}\\Share_Design', f'{domain_user}', f'{AdminPD}'),
    ('J', f'\\\\{fileserver_ip}\\Share_Distribution', f'{domain_user}', f'{AdminPD}'),
    ('K', f'\\\\{fileserver_ip}\\Share_Finance', f'{domain_user}', f'{AdminPD}'),
    ('L', f'\\\\{fileserver_ip}\\Share_HR', f'{domain_user}', f'{AdminPD}'),
    ('M', f'\\\\{fileserver_ip}\\Share_IT', f'{domain_user}', f'{AdminPD}'),
    ('N', f'\\\\{fileserver_ip}\\Share_Marketing', f'{domain_user}', f'{AdminPD}'),
    ('O', f'\\\\{fileserver_ip}\\Share_Operations', f'{domain_user}', f'{AdminPD}'),
    ('P', f'\\\\{fileserver_ip}\\Share_Production', f'{domain_user}', f'{AdminPD}'),
    ('Q', f'\\\\{fileserver_ip}\\Share_Quality', f'{domain_user}', f'{AdminPD}'),
    ('R', f'\\\\{fileserver_ip}\\Share_R&D', f'{domain_user}', f'{AdminPD}'),
    ('S', f'\\\\{fileserver_ip}\\Share_Sales', f'{domain_user}', f'{AdminPD}'),
    ('T', f'\\\\{fileserver_ip}\\Share_Stores', f'{domain_user}', f'{AdminPD}'),
    ('U', f'\\\\{fileserver_ip}\\Share_Support', f'{domain_user}', f'{AdminPD}')
]
if __name__ == "__main__":
    logging.info("Daily User Usage Start")
    main(url,extensions,urls_to_open_init,files_to_open_init,progs_to_open_init,programs,drive_mappings,morning_ad_login,afternoon_ad_login,domain,username,AdminPD,domain_user,ad_server)
