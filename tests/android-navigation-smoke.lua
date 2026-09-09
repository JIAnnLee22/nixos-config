-- Run from the repository root with:
-- nvim --headless -u NONE -l tests/android-navigation-smoke.lua
local nvim_root = vim.fn.getcwd() .. '/dotfile/nvim'
vim.opt.runtimepath:prepend(nvim_root)
vim.cmd('filetype on')

local fixture = vim.fn.tempname()
local sdk = fixture .. '/sdk'
local project = fixture .. '/project'
vim.fn.mkdir(sdk .. '/sources/android-35/android/view', 'p')
vim.fn.mkdir(project .. '/app/src/main/res/layout', 'p')
vim.fn.mkdir(project .. '/app/src/main/res/values', 'p')
vim.fn.mkdir(project .. '/app/src/main/kotlin/com/example', 'p')
vim.fn.writefile({ 'rootProject.name = "android-navigation-smoke"' }, project .. '/settings.gradle.kts')
vim.fn.writefile({ 'compileSdk = 35' }, project .. '/app/build.gradle.kts')
vim.fn.writefile({ 'sdk.dir=' .. sdk }, project .. '/local.properties')
vim.fn.writefile({
  '<LinearLayout>',
  '  <TextView android:id="@+id/title" />',
  '</LinearLayout>',
}, project .. '/app/src/main/res/layout/main.xml')
vim.fn.writefile({ '<resources><string name="app_name">Smoke</string></resources>' },
  project .. '/app/src/main/res/values/strings.xml')
vim.fn.writefile({ 'package android.view', 'public class View {}' },
  sdk .. '/sources/android-35/android/view/View.java')

local util = require('android.util')
local sdk_module = require('android.sdk')
local resources = require('android.resources')
local dependency = require('android.dependency')

assert(util.find_project_root(project .. '/app/src/main') == project, 'Gradle project root detection failed')
assert(util.get_sdk_dir({ root = project }) == sdk, 'local SDK resolution failed')
assert(util.get_compile_sdk(project) == '35', 'compileSdk parsing failed')
assert(util.get_sources_root(sdk, '35') == sdk .. '/sources/android-35', 'SDK sources resolution failed')
assert(sdk_module.find_sdk_source('android.view.View', { startpath = project }) ==
  sdk .. '/sources/android-35/android/view/View.java', 'SDK source navigation failed')
assert(resources.find_resource_file('layout', 'main', { root = project }) ==
  project .. '/app/src/main/res/layout/main.xml', 'layout navigation failed')
assert(resources.find_resource_file('id', 'title', { root = project }) ==
  project .. '/app/src/main/res/layout/main.xml', 'layout ID navigation failed')
assert(resources.find_resource_file('string', 'app_name', { root = project }) ==
  project .. '/app/src/main/res/values/strings.xml', 'values resource navigation failed')
local archive, entry = dependency._decode_uri(
  'jar:file:///tmp/library-1.0-sources.jar!/com/example/Library.kt')
assert(archive == '/tmp/library-1.0-sources.jar' and entry == 'com/example/Library.kt',
  'Gradle source JAR URI parsing failed')
local source_entries = dependency._source_entry_candidates('com/example/Library.class')
assert(vim.tbl_contains(source_entries, 'com/example/Library.kt')
  and vim.tbl_contains(source_entries, 'com/example/Library.java'),
  'binary-to-source JAR entry mapping failed')

print('PASS: Android project root, SDK source, resource and source-JAR navigation')
vim.fn.delete(fixture, 'rf')
vim.cmd('qa!')
