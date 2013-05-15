/**
 * Copyright 2013 Ben Vanik. All Rights Reserved.
 *
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 */

/**
 * @fileoverview Github API for the browser.
 * This is super simple and only meant for anonymous querying of repo info.
 *
 * @author ben.vanik@gmail.com (Ben Vanik)
 */

(function(global, exports) {


var API_URL = 'https://api.github.com';


function makeRepoUrl(owner, repo, var_args) {
  var url = [API_URL, '/repos/', owner, '/', repo];
  for (var n = 2; n < arguments.length; n++) {
    url.push('/');
    url.push(arguments[n]);
  }
  return url.join('');
};


function getRequest(url, options, callback) {
  var xhr = new XMLHttpRequest();
  xhr.open('GET', url, true);
  xhr.setRequestHeader('Content-Type','application/json');
  if (options && options.format == 'binary') {
    xhr.responseType = 'arraybuffer';
    xhr.overrideMimeType('text/plain; charset=x-user-defined');
  }

  xhr.onreadystatechange = function() {
    if (xhr.readyState != 4) {
      return;
    }

    if ((xhr.status >= 200 && xhr.status < 300) ||
        (xhr.status === 304)) {
      if (options && options.format == 'binary') {
        callback(null, xhr.response);
      } else if (options && options.format == 'json') {
        callback(null, JSON.parse(xhr.responseText));
      } else {
        callback(null, xhr.responseText);
      }
    } else {
      callback(xhr.status, null);
    }
  };

  if (options.data) {
    xhr.send(JSON.stringify(options.data));
  } else {
    xhr.send();
  }
};


function queryRepository(owner, repo, callback) {
  getRequest(
      makeRepoUrl(owner, repo), {
        format: 'json'
      }, function(error, result) {
        callback(error, result);
      });
};


function listCommits(owner, repo, callback) {
  getRequest(
      makeRepoUrl(owner, repo, 'commits'), {
        format: 'json'
      }, function(error, result) {
        callback(error, result);
      });
};


exports.github = {
  queryRepository: queryRepository,
  listCommits: listCommits
};


})(window, window);
