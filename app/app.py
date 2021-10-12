"""
Technical Exercise for ID.me
by Joel Caturia <jcaturi@katratech.com>
"""

import os

import validators

from flask import Flask, render_template, escape, request
from werkzeug.utils import redirect

import sentry_sdk
from sentry_sdk.integrations.flask import FlaskIntegration

from db_functions import fetch_url_record, fetch_all_url_records
from db_functions import update_url_record, update_hit_counter


SENTRY_DSN   = os.environ['APP_SENTRY_DSN']

# Setup our Sentry error logging as one of the first things we do
sentry_sdk.init(                         # pylint: disable=E0110
    dsn=SENTRY_DSN,
    integrations=[FlaskIntegration()],
    traces_sample_rate=1.0, debug=False
)


# We want to have build information burned into our application,
# but make sure we don't crash and burn in case it's malformed
# I would conside this "fail-safe" behavior
try:
    from build_info import BUILD_DATE
except Exception as err:                 # pylint: disable=W0703
    sentry_sdk.capture_exception(err)
finally:
    if not BUILD_DATE:
        BUILD_DATE = 'Unknown'

try:
    from build_info import BUILD_TIME
except Exception as err:                 # pylint: disable=W0703
    sentry_sdk.capture_exception(err)
finally:
    if not BUILD_TIME:
        BUILD_TIME = 'Unknown'

try:
    from build_info import BUILD_TAG
except Exception as err:                 # pylint: disable=W0703
    sentry_sdk.capture_exception(err)
finally:
    if not BUILD_TAG:
        BUILD_TAG = 'Unknown'

BUILD_INFO = (BUILD_DATE, BUILD_TIME, BUILD_TAG)


app = Flask(__name__)




###########################################################
### HOME
###########################################################
@app.route('/', defaults={'_path': ''})
@app.route('/<path:_path>')
def home(_path = None):
    """
    Main (Home) route when no other valid entries are provided in the URL
    """

    all_urls = fetch_all_url_records()

    return render_template(
        'index.html', build_info=BUILD_INFO, url_list=all_urls, message=None)


###########################################################
### PERFORM REDIRECT
###########################################################
@app.route('/<string:short_url>', methods=['GET'])
def perform_redirect(short_url):
    """
    This function is called when we specify a single parameter (hopefully a valid short URL)
    """

    short_url = escape(short_url.lower())

    record = fetch_url_record(short_url)

    if record:
        # Since "sidecar_text" is an optional field.
        # Make sure our code does not panic if it does not exist
        if 'sidecar_text' not in record:
            record['sidecar_text'] = None

        update_hit_counter(record['_id'])

        return render_template(
            'redirect.html', redirect_seconds=5,
            url=record['long_url'], arbitrary_text=record['sidecar_text'], build_info=BUILD_INFO)

    message = f'That short URL [{short_url}] does not exist. Woul you like to create it?'

    return render_template(
        'update.html', message=message, single_record = {}, build_info=BUILD_INFO)


###########################################################
### CREATE NEW SHORT URL
###########################################################
@app.route('/create', defaults={'short_url': None}, methods=['GET', 'POST'])
@app.route('/create/<string:short_url>', methods=['GET'])
def create(short_url):
    """
    This function is called when we want to create a short URL
    """

    # When we first GET the page, this renders our create HTML UI
    if request.method == "GET":
        single_record = {}
        single_record['name']         = short_url
        single_record['long_url']     = ''
        single_record['sidecar_text'] = 'Hello world!'

        return render_template(
            'update.html', message=None, single_record=single_record, build_info=BUILD_INFO)

    # and if we get here, this is our POST, so we do some database insert work
    short_url     = request.form.get('name')
    short_url     = short_url.lower()

    long_url      = request.form.get('long_url')
    sidecar_text  = request.form.get('sidecar_text')

    single_record = {}
    single_record['name']         = short_url
    single_record['long_url']     = long_url
    single_record['sidecar_text'] = sidecar_text

    # Validate the fields
    validation_dict = {}

    if not validators.slug(short_url):
        single_record.pop('name')
        validation_dict['name'] = 'Please enter a valid short URL slug (alphanumeric \
                                characters, hyphens and underscores).'

    if not validators.url(long_url, public=True):
        validation_dict['long_url'] = 'Please enter a properly formatted URL'

    if len(validation_dict) > 0:
        return render_template(
            'update.html', message=None, single_record=single_record,
                validation_dict=validation_dict, build_info=BUILD_INFO)

    # If we were doing authenticated sessions, I'd use that data right here
    owner = 'Default Owner'

    update_url_record(short_url, long_url, sidecar_text, owner = owner)

    return redirect('/', 302)


###########################################################
### UPDATE AN EXISTING SHORT URL
###########################################################
@app.route('/update/<string:short_url>', methods=['GET', 'POST'])
def update(short_url):
    """
    This function is called when we want to update a short URL
    """
    message = None
    single_record = fetch_url_record(short_url)

    # When we first GET the page, this renders our HTML UI
    if request.method == "GET":
        return render_template(
            'update.html', message=message, single_record=single_record, build_info=BUILD_INFO)

    # and if we get here it was a POST, so we do some database work
    long_url      = request.form.get('long_url')
    sidecar_text  = request.form.get('sidecar_text')

    # Validate the fields
    validation_dict = {}

    if not validators.url(long_url, public=True):
        validation_dict['long_url'] = 'This is not a valid URL'

        single_record = {}
        single_record['name']         = short_url
        single_record['long_url']     = long_url
        single_record['sidecar_text'] = sidecar_text

        return render_template(
            'update.html', message=message, single_record=single_record,
                validation_dict=validation_dict, build_info=BUILD_INFO)

    # If we were doing authenticated sessions, I'd use that data right here
    # This is also just "laziness" on my part. Perhaps we don't actually
    # want to change the owner every time the record is updated - I do though :)
    owner = 'Default Owner'

    update_url_record(short_url, long_url, sidecar_text, owner=owner)

    return redirect('/', 302)


###########################################################
### CONTINUOUS DEPLOYMENT HEALTH CHECK
###########################################################
@app.route('/healthcheck', methods=['GET'])
def health_check():
    """
    Do a database read, and if we return some results then we return OK and our BUILD_TAG
    """
    search_result = fetch_all_url_records()
    if search_result:
        status = {'status': 'OK!', 'build_tag': BUILD_TAG}
        return status

    status = {'status': 'ERROR!', 'build_tag': BUILD_TAG}
    return 'Error?'


###########################################################
### DEMONSTRATION FUNCTIONS
###########################################################
@app.route('/exception', methods=['GET'])
def crash_and_burn():
    """
    This function is called when we want to test out error handling
    """
    raise Exception('An error has occured .. but you knew that already!')


@app.route('/loaderio-2c654ab231db9465ea34235c1ce52db5/')
@app.route('/loaderio-2c654ab231db9465ea34235c1ce52db5.txt')
def validation():
    """
    Validation code for Loader.io
    FIXME - I want this to be dynamic based on pattern matching (always starts with loaderio-
    """
    return 'loaderio-2c654ab231db9465ea34235c1ce52db5'
###########################################################




if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
