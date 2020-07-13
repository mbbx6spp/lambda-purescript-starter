"use strict";

const express = require('express');
const OPTIONS = {
  limit: '10kb',
  strict: true
};

exports._jsonParser = function(req, res, next) {
    return function() {
      return express.json(OPTIONS)(req, res, next);
    };
}

exports._urlencodedParser = function(req, res, next) {
  return function() {
    return express.urlencoded(OPTIONS)(req, res, next);
  };
};
