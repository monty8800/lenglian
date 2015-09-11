'use strict';

var webpack = require('webpack'),
    HtmlWebpackPlugin = require('html-webpack-plugin'),
    path = require('path'),
    srcPath = path.join(__dirname, 'src'),
    coffeePath = path.join(srcPath, 'coffee');

var WebpackOnBuildPlugin = require('on-build-webpack');
var process = require('child_process');
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

//TODO
process.exec('grep -r "TODO" src -n > TODO.md');

function prepare() {
    if (busy === true) {
        return;
    }
    busy = true;
    console.log('cordova prepare!');
    process.exec('cordova prepare');
}

var config = {
    target: 'web',
    cache: true,
    entry: {
        util: ['mobile-util']
    },
    resolve: {
        root: __dirname,
        extensions: ['', '.coffee', '.js', '.cjsx', '.css', 'woff', '.json', '.png'],
        modulesDirectories: ['src/coffee', 'build/css', 'node_modules'],
        alias: {
            "zepto": "bower_components/zepto/zepto.min", // var $ = require('zepto')
            "swiper": "bower_components/swiper/dist/js/swiper.min",
            "fastclick": "node_modules/fastclick/lib/fastclick",
            "lazyload": "bower_components/xe-common/js/lazyload",
            "mobile-util": "bower_components/xe-common/js/mobileUtil",
            "xe": "bower_components/xe-common/js/xe",
            "majia-style": "build/css/majia.css",
            "index-style": "build/css/index.css",
            "crypto": "node_modules/crypto-browserify"
        }
    },
    output: {
        path: path.join(__dirname, 'www'),
        publicPath: '',
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
            loader: "coffee-jsx-loader"
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
            loader: 'style!css'
        }, {
            test: /\.(woff|svg|ttf|eot)$/,
            loader: 'url'
        },{
            test: /\.json$/,
            loader: 'json'
        },{
            test: /\.png$/,
            loader: 'url-loader?mimetype=image/png'
        }]
    },
    plugins: [
        new webpack.optimize.CommonsChunkPlugin('common', 'common.js'),
        new webpack.optimize.UglifyJsPlugin({
            compress: {
                warnings: false
            }
        }),
        new webpack.optimize.DedupePlugin(),
        new HtmlWebpackPlugin({
            inject: true,
            filename: 'index.html',
            chunks: ['common'],
            template: 'src/template/index.html'
        }),
        new webpack.NoErrorsPlugin(),
    ],

    debug: true,
    devtool: 'eval-cheap-module-source-map',
    devServer: {
        contentBase: './www',
        historyApiFallback: true,
        proxy: {
            "!(http)*!(html|js)": "http://localhost:3000" //把请求通过app.js代理一下，解决跨域
        }
    }
};



for (var i = 0; i < pages.length; i++) {
    var page = pages[i];

    //自动生成js
    config.entry[page.file] = 'components/' + page.folder + '/' + page.file + '.page';


    //自动生成html
    config.plugins.push(new HtmlWebpackPlugin({
        inject: true,
        filename: page.file + '.html',
        chunks: ['common', page.file],
        template: 'src/template/index.html'
    }));
}

module.exports = config;