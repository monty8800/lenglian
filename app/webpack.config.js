'use strict';

var webpack = require('webpack'),
    HtmlWebpackPlugin = require('html-webpack-plugin'),
    path = require('path'),
    srcPath = path.join(__dirname, 'src'),
    coffeePath = path.join(srcPath, 'coffee');

var ExtractTextPlugin = require("extract-text-webpack-plugin");

var fs = require('fs');

var busy = false;

var pages = [];


//遍历找到.page后缀的文件，用于自动生成页面
var folders = fs.readdirSync(path.join(coffeePath, 'components'));
for (var i = 0; i < folders.length; i++) {
    var files = fs.readdirSync(path.join(coffeePath, 'components', folders[i]));
    for (var j = 0; j < files.length; j++) {
        var file = files[j];
        var index = file.indexOf('.page.');
        if (index !== -1) {
            pages.push({
                file: file.slice(0, index),
                folder: folders[i]
            });
        }
    }
}

console.log('out pages', pages);


var config = {
    target: 'web',
    cache: true,
    entry: {
    },
    resolve: {
        root: __dirname,
        extensions: ['', '.coffee', '.js', '.cjsx', '.css', '.woff', '.svg', '.ttf', '.eot', '.json', '.png', '.jpg'],
        modulesDirectories: ['src/coffee', 'build/css', 'build/images', 'node_modules'],
        alias: {
            "zepto": "bower_components/zepto/zepto.min", // var $ = require('zepto')
            "swiper": "bower_components/swiper/dist/js/swiper.min",
            "fastclick": "node_modules/fastclick/lib/fastclick",
            "lazyload": "bower_components/xe-common/js/lazyload",
            "mobile-util": "bower_components/xe-common/js/mobileUtil",
            "xe": "bower_components/xe-common/js/xe",
            "majia-style": "build/css/majia.css",
            "index-style": "build/css/index.css",
            "user-center-style": "build/css/userCenter.css",
            "crypto": "node_modules/crypto-browserify"
        }
    },
    output: {
        path: path.join(__dirname, 'www'),
        publicPath: '/',
        filename: '[name].js',
        library: ['Example', '[name]'],
        pathInfo: true
    },

    module: {
        loaders: [{
            test: /\.coffee$/,
            exclude: /node_modules/,
            loader: 'coffee'
        }, {
            test: /\.cjsx$/,
            exclude: /node_modules/,
            loaders: ['react-hot', "coffee-jsx-loader"]
        }, {
            test: /\.*zepto(\.min)?\.js$/,
            loader: "exports?Zepto"
        }, {
            test: /\.*swiper(\.min)?\.js$/,
            loader: "exports?Swiper"
        }, {
            test: /\.*fastclick(\.min)?\.js$/,
            loader: "exports"
        }, {
            test: /\.*lazyload(\.min)?\.js$/,
            loader: "exports?Swiper"
        }, {
            test: /\.*css$/,
            loader:  ExtractTextPlugin.extract("style-loader", "css-loader")
        }, {
            test: /\.(woff|svg|ttf|eot)$/,
            loader: 'url'
        },{
            test: /\.json$/,
            loader: 'json'
        },{ 
            test: /\.(jpe?g|png|gif|svg)$/i,
            loader: 'url?limit=10000!img?progressive=true'
        }]
    },
    plugins: [
        new webpack.optimize.CommonsChunkPlugin('common', 'common.js'),
        new ExtractTextPlugin("[name].css", {
            allChunks: true
        }),
        new HtmlWebpackPlugin({
            inject: true,
            filename: 'index.html',
            chunks: ['common'],
            template: 'src/template/index.html'
        }),
        new webpack.NoErrorsPlugin(),
    ],
};



for (var i = 0; i < pages.length; i++) {
    var page = pages[i];

    //自动生成js
    config.entry[page.file] = ['components/' + page.folder + '/' + page.file + '.page'];


    //自动生成html
    config.plugins.push(new HtmlWebpackPlugin({
        inject: true,
        minify: true,
        title: page.file,
        hash: true,
        filename: page.file + '.html',
        chunks: ['common', page.file],
        template: 'src/template/index.html'
    }));
}

module.exports = config;