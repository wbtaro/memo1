# frozen_string_literal: true

require "securerandom"

class Memo
  MEMO_DIR = __dir__ + "/memo"
  attr_reader :title, :id, :content

  # メモ一覧を返却
  def self.list
    memo_list = []
    id_list.each do |id|
      File.open(MEMO_DIR + "/" + id) do |file|
        # メモの1行目がタイトル代わり
        memo_list << Memo.new(file.read.split("\n")[0], id)
      end
    end
    memo_list
  end

  # メモの内容を読み取る
  def self.read(id)
    File.open(MEMO_DIR + "/" + id) do |file|
      content = file.read
      Memo.new(content.split("\n")[0], id, content)
    end
  end

  # メモを新規作成
  def self.create(content)
    File.open(MEMO_DIR + "/" + new_memo_id, "w") { |file| file.print content }
  end

  # メモを編集
  def self.edit(id, content)
    File.open(MEMO_DIR + "/" + id, "w") { |file| file.print content }
  end

  # メモを削除
  def self.delete(id)
    File.delete(MEMO_DIR + "/" + id)
  end

  def initialize(title, file_name, content = "")
    @title = title
    @id = file_name
    @content = content
  end

  private
    # メモファイルの一覧を返す
    def self.id_list
      Dir.children(MEMO_DIR)
    end

    # 新規作成するメモのIDを決定
    def self.new_memo_id
      SecureRandom.uuid
    end
end
