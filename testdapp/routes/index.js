var path = require('path');
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.sendFile(path.join(__dirname, '../index.html'));
});

router.get('/abi.js', function(req, res, next) {
  res.sendFile(path.join(__dirname, '../abi.js'));
});

module.exports = router;
