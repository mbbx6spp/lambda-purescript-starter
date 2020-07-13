const awsServerlessExpress = require("aws-serverless-express");
const express = require('express');
const helmet = require('helmet');

exports.makeApplication = function() {
  const app = express();
  app.use(helmet());
  return app;
};

exports.createServer = awsServerlessExpress.createServer;

exports.proxy = function(server) {
  return function handler(event, context) {
    awsServerlessExpress.proxy(server, event, context);
  };
};
