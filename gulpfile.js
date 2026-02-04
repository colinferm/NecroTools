/*
 * NecroTools Gulp Build Configuration
 * Replaces Gruntfile.js functionality
 */
var gulp = require('gulp');
var concat = require('gulp-concat');
var sass = require('gulp-sass')(require('sass'));
var header = require('gulp-header');
var through2 = require('through2');
var path = require('path');
var del = require('del');

// Paths configuration
var paths = {
    js: {
        src: [
            '/var/www/html/js/utils/packages.js',
            '/var/www/html/js/utils/router.js',
            '/var/www/html/js/utils/base-form-view.js',
            '/var/www/html/js/utils/base-list-views.js',
            '/var/www/html/js/utils/base-modal.js',
            '/var/www/html/js/models/user/**/*.js',
            '/var/www/html/js/models/gang/**/*.js',
            '/var/www/html/js/models/campaign/**/*.js',
            '/var/www/html/js/models/messaging/**/*.js',
            '/var/www/html/js/views/**/*.js'
        ],
        dest: '/var/www/html/js/',
        output: 'necro.js'
    },
    templates: {
        src: '/var/www/html/tmpl/**/*.html',
        dest: '/var/www/html/js/',
        output: 'templates.js'
    },
    sass: {
        src: '/var/www/html/**/*.scss',
        dest: '/var/www/html/'
    }
};

// Get current timestamp for banner
function getTimestamp() {
    var now = new Date();
    return now.toISOString().replace('T', ', ').substring(0, 22);
}

// Clean compiled files
function clean() {
    return del([
        '/var/www/html/js/necro.js',
        '/var/www/html/js/templates.js'
    ], { force: true });
}

// Concatenate JavaScript files
function scripts() {
    var banner = '/* Compiled: ' + getTimestamp() + ' */\n';

    return gulp.src(paths.js.src, { allowEmpty: true })
        .pipe(concat(paths.js.output))
        .pipe(header(banner))
        .pipe(gulp.dest(paths.js.dest));
}

// Process HTML templates - wrap in script tags
function templates() {
    return gulp.src(paths.templates.src, { allowEmpty: true })
        .pipe(through2.obj(function(file, enc, callback) {
            if (file.isBuffer()) {
                var filename = path.basename(file.path, '.html');
                var content = file.contents.toString();
                var wrapped = '<script type="text/tempate" id="' + filename + '">\n' +
                    content + '\n</script>\n';
                file.contents = Buffer.from(wrapped);
            }
            callback(null, file);
        }))
        .pipe(concat(paths.templates.output))
        .pipe(gulp.dest(paths.templates.dest));
}

// Compile SASS to CSS
function styles() {
    return gulp.src(paths.sass.src, { allowEmpty: true })
        .pipe(sass().on('error', sass.logError))
        .pipe(gulp.dest(paths.sass.dest));
}

// Watch for file changes
function watchFiles() {
    gulp.watch([
        '/var/www/html/js/**/*.js',
        '!/var/www/html/js/necro.js',
        '!/var/www/html/js/templates.js',
        '!/var/www/html/js/libs/**'
    ], scripts);

    gulp.watch('/var/www/html/tmpl/**/*.html', templates);
    gulp.watch('/var/www/html/**/*.scss', styles);
}

// Build all assets
var build = gulp.series(clean, gulp.parallel(scripts, templates, styles));

// Refresh task (clean and rebuild)
var refresh = gulp.series(clean, gulp.parallel(scripts, templates, styles));

// Default task - build and watch
var defaultTask = gulp.series(build, watchFiles);

// Export tasks
exports.clean = clean;
exports.scripts = scripts;
exports.templates = templates;
exports.styles = styles;
exports.watch = watchFiles;
exports.build = build;
exports.refresh = refresh;
exports.default = defaultTask;
