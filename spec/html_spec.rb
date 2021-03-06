# -*- Encoding: utf-8 -*-
#
# Copyright 2013 whiteleaf. All rights reserved.
#

require_relative "../lib/html"

html_test_html_path = File.expand_path(File.dirname(__FILE__) + "/data/html_test.html")
html_test_txt_path = File.expand_path(File.dirname(__FILE__) + "/data/html_test.txt")

describe HTML do
  before do
    @html = HTML.new("")
  end

  it "rubyタグ → 青空ルビ注記" do
    rubies = [
      ["<ruby>漢字<rt>かんじ</ruby>", "｜漢字《かんじ》"],
      ["<ruby><rb>八九三<rp>（<rt>やくざ<rp>）</ruby>", "｜八九三《やくざ》"],
      ["<ruby><rb>堪能</rb><rp>(</rp><rt>たんのう</rt><rp>)</rp></ruby>", "｜堪能《たんのう》"],
      ["<ruby>漢字</ruby>", "漢字"],
      ["この文章の中にルビはない", "この文章の中にルビはない"],
      ["美食を<ruby><rb>堪能</rb><rp>(</rp><rt>たんのう</rt><rp>)</rp></ruby>した", "美食を｜堪能《たんのう》した"],
    ]
    rubies.each do |ruby|
      @html.ruby_to_aozora(ruby[0]).should == ruby[1]
    end
  end

  it "<b> → 太字" do
    @html.b_to_aozora("次の文字は<b>太字</b>に").should == "次の文字は［＃太字］太字［＃太字終わり］に"
  end

  it "<i> → 斜体" do
    @html.i_to_aozora("次の文字は<i>斜体</i>に").should == "次の文字は［＃斜体］斜体［＃斜体終わり］に"
  end

  it "<s> → 取消線" do
    @html.s_to_aozora("次の文字は<s>取消線</s>に").should == "次の文字は［＃取消線］取消線［＃取消線終わり］に"
  end

  it "<br> → 改行" do
    @html.br_to_aozora("あいう<br>かきく<br />\nさしす<BR>").should == "あいう\nかきく\nさしす\n"
  end

  it "<img> → 挿絵注記" do
    @html.img_to_aozora('<img src="./images/100.jpg">').should == "［＃挿絵（./images/100.jpg）入る］"
    @html.set_illust_setting(current_url: "http://novel.example.com/10510/")
    @html.img_to_aozora('<img src="./images/100.jpg">').should ==
                        "［＃挿絵（http://novel.example.com/10510/images/100.jpg）入る］"
    @html.set_illust_setting(current_url: nil)
  end

  it "HTML#to_aozora" do
    test_html = File.read(html_test_html_path, encoding: "utf-8")
    test_txt = File.read(html_test_txt_path, encoding: "utf-8")
    html = HTML.new(test_html)
    html.to_aozora.should == test_txt
  end
end
