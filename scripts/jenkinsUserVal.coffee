# Description:
#   Which is Better?
#
# Dependencies:
#   None
#
# Configuration:
#   None
# 
# Commands:
#   hubot which is better[?] <text> or <text>?
#   hubot who is better[?] <text> or <text>?
#   hubot which is worse[?] <text> or <text>?
#   hubot who is worse[?] <text> or <text>?
#
# Author:
#   cpradio

uhh_what = [
    "I could tell you, but then I'd have to kill you",
    "Answering that would be a matter of national security",
    "You can't possibly compare them!",
    "Both hold a special place in my heart"
  ]

s4 = () ->
  Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)

module.exports = (robot) ->
  robot.respond /(which|who) is (better|worse)\?* (.*) or (.*?)\??$/i, (msg) ->
    choosen_response = msg.random [1..5]
    sm = "#{s4(msg)}#{s4(msg)}"
    userName = msg.message.user.name
    fileName = "./#{userName}.json"
    fs = require 'fs'
    fileContent = fs.readFileSync fileName, 'utf8'
    data = JSON.parse(fileContent)
    key = data.key
    msg.send  "#{key} is the value"
    resultJson = {}
    resultJson.username = "#{userName}"
    resultJson.key = "#{sm}"
    resultJson.isAuth = false
    result = JSON.stringify(resultJson)
    fs.writeFile(fileName, JSON.stringify(resultJson), (error) -> throw error if error)
    msg.send "#{result} trimmed hash #{sm}"

  robot.respond /j(?:enkins)? register dev( (.*))?/i, (msg) ->
    fs = require 'fs'
    usersFileName = "./config/devusers.json"
    userListJson = fs.readFileSync usersFileName, 'utf8'
    userList = JSON.parse(userListJson)
    userListArray = userList.users
    newUser = msg.message.user.name
    arrayLength = userListArray.length
    for user in userListArray
      if user.username == newUser
        msg.send "User #{newUser} already Exists"
        return 
    sm = "#{s4()}#{s4()}"
    resultJson = {}
    resultJson.username = "#{newUser}"
    resultJson.key = "#{sm}"
    resultJson.isAuth = false
    userListArray.push(resultJson)
    userList.users = userListArray
    fs.writeFile(usersFileName, JSON.stringify(userList), (error) -> throw error if error)
    msg.send "Successfully registered #{newUser} with key #{sm}"


  robot.respond /j(?:enkins)? register prod( (.*))?/i, (msg) ->
    fs = require 'fs'
    usersFileName = "./config/produsers.json"
    userListJson = fs.readFileSync usersFileName, 'utf8'
    userList = JSON.parse(userListJson)
    userListArray = userList.users
    newUser = msg.message.user.name
    arrayLength = userListArray.length
    for user in userListArray
      if user.username == newUser
        msg.send "User #{newUser} already Exists"
        return
    sm = "#{s4()}#{s4()}"
    resultJson = {}
    resultJson.username = "#{newUser}"
    resultJson.key = "#{sm}"
    resultJson.isAuth = false
    userListArray.push(resultJson)
    userList.users = userListArray
    fs.writeFile(usersFileName, JSON.stringify(userList), (error) -> throw error if error)
    msg.send "Successfully registered #{newUser} with key #{sm}"

  robot.respond /j(?:enkins)? admin list prod --key=(.*)/i, (msg) ->
    adminKey = msg.match[1]
    fs = require 'fs'
    adminConfig = "./config/admin.json"
    adminConfigJson = fs.readFileSync adminConfig, 'utf8'
    adminJson = JSON.parse(adminConfigJson)
    adminPassKey = adminJson.key
    if adminPassKey != adminKey
      msg.send "Invalid Key provided for admin"
      return
    usersFileName = "./config/produsers.json"
    adminJson = fs.readFileSync usersFileName, 'utf8'
    userList = JSON.parse(adminJson)
    resultData = JSON.stringify(userList)
    msg.send "Prod Users are #{resultData}"

  robot.respond /j(?:enkins)? admin list dev --key=(.*)/i, (msg) ->
    adminKey = msg.match[1]
    fs = require 'fs'
    adminConfig = "./config/admin.json"
    adminConfigJson = fs.readFileSync adminConfig, 'utf8'
    adminJson = JSON.parse(adminConfigJson)
    adminPassKey = adminJson.key
    if adminPassKey != adminKey
      msg.send "Invalid Key provided for admin"
      return
    usersFileName = "./config/devusers.json"
    adminJson = fs.readFileSync usersFileName, 'utf8'
    userList = JSON.parse(adminJson)
    resultData = JSON.stringify(userList)
    msg.send "Prod Users are #{resultData}"

  robot.respond /j(?:enkins)? admin approve dev --key=(.*) --user=(.*)/i, (msg) ->
    adminKey = msg.match[1]
    fs = require 'fs'
    adminConfig = "./config/admin.json"
    adminConfigJson = fs.readFileSync adminConfig, 'utf8'
    adminJson = JSON.parse(adminConfigJson)
    adminPassKey = adminJson.key
    if adminPassKey != adminKey
      msg.send "Invalid Key provided for admin"
      return
    usersFileName = "./config/devusers.json"
    userListJson = fs.readFileSync usersFileName, 'utf8'
    userList = JSON.parse(userListJson)
    userListArray = userList.users
    newUser = msg.match[2]
    globalUserArray = []
    for user in userListArray
      if user.username == newUser
        resultJson = {}
        resultJson.username = user.username
        resultJson.key = user.key
        resultJson.isAuth = true
        globalUserArray.push(resultJson)
      else
        globalUserArray.push(user)
    updatedUserList = {}
    updatedUserList.users = globalUserArray
    fs.writeFile(usersFileName, JSON.stringify(updatedUserList), (error) -> throw error if error)
    msg.send "Successfuly Updated User #{newUser}"

  robot.respond /j(?:enkins)? admin decline dev --key=(.*) --user=(.*)/i, (msg) ->
    adminKey = msg.match[1]
    fs = require 'fs'
    adminConfig = "./config/admin.json"
    adminConfigJson = fs.readFileSync adminConfig, 'utf8'
    adminJson = JSON.parse(adminConfigJson)
    adminPassKey = adminJson.key
    if adminPassKey != adminKey
      msg.send "Invalid Key provided for admin"
      return
    usersFileName = "./config/devusers.json"
    userListJson = fs.readFileSync usersFileName, 'utf8'
    userList = JSON.parse(userListJson)
    userListArray = userList.users
    newUser = msg.match[2]
    globalUserArray = []
    for user in userListArray
      if user.username == newUser
        resultJson = {}
        resultJson.username = user.username
        resultJson.key = user.key
        resultJson.isAuth = false
        globalUserArray.push(resultJson)
      else
        globalUserArray.push(user)
    updatedUserList = {}
    updatedUserList.users = globalUserArray
    fs.writeFile(usersFileName, JSON.stringify(updatedUserList), (error) -> throw error if error)
    msg.send "Successfuly Updated User #{newUser}"

  robot.respond /j(?:enkins)? admin approve prod --key=(.*) --user=(.*)/i, (msg) ->
    adminKey = msg.match[1]
    fs = require 'fs'
    adminConfig = "./config/admin.json"
    adminConfigJson = fs.readFileSync adminConfig, 'utf8'
    adminJson = JSON.parse(adminConfigJson)
    adminPassKey = adminJson.key
    if adminPassKey != adminKey
      msg.send "Invalid Key provided for admin"
      return
    usersFileName = "./config/produsers.json"
    userListJson = fs.readFileSync usersFileName, 'utf8'
    userList = JSON.parse(userListJson)
    userListArray = userList.users
    newUser = msg.match[2]
    globalUserArray = []
    for user in userListArray
      if user.username == newUser
        resultJson = {}
        resultJson.username = user.username
        resultJson.key = user.key
        resultJson.isAuth = true
        globalUserArray.push(resultJson)
      else
        globalUserArray.push(user)
    updatedUserList = {}
    updatedUserList.users = globalUserArray
    fs.writeFile(usersFileName, JSON.stringify(updatedUserList), (error) -> throw error if error)
    msg.send "Successfuly Updated User #{newUser}"

  robot.respond /j(?:enkins)? admin decline prod --key=(.*) --user=(.*)/i, (msg) ->
    adminKey = msg.match[1]
    fs = require 'fs'
    adminConfig = "./config/admin.json"
    adminConfigJson = fs.readFileSync adminConfig, 'utf8'
    adminJson = JSON.parse(adminConfigJson)
    adminPassKey = adminJson.key
    if adminPassKey != adminKey
      msg.send "Invalid Key provided for admin"
      return
    usersFileName = "./config/produsers.json"
    userListJson = fs.readFileSync usersFileName, 'utf8'
    userList = JSON.parse(userListJson)
    userListArray = userList.users
    newUser = msg.match[2]
    globalUserArray = []
    for user in userListArray
      if user.username == newUser
        resultJson = {}
        resultJson.username = user.username
        resultJson.key = user.key
        resultJson.isAuth = false
        globalUserArray.push(resultJson)
      else
        globalUserArray.push(user)
    updatedUserList = {}
    updatedUserList.users = globalUserArray
    fs.writeFile(usersFileName, JSON.stringify(updatedUserList), (error) -> throw error if error)
    msg.send "Successfuly Updated User #{newUser}"
