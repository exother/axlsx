# encoding: UTF-8
# frozen_string_literal: true
module Axlsx
  # Table
  # @note Worksheet#add_pivot_table is the recommended way to create tables for your worksheets.
  # @see README for examples
  class PivotTableCacheDefinition

    include Axlsx::OptionsParser

    # Creates a new PivotTable object
    # @param [String] pivot_table The pivot table this cache definition is in
    def initialize(pivot_table)
      @pivot_table = pivot_table
    end

    # # The reference to the pivot table data
    # # @return [PivotTable]
    attr_reader :pivot_table

    # The index of this chart in the workbooks charts collection
    # @return [Integer]
    def index
      pivot_table.sheet.workbook.pivot_tables.index(pivot_table)
    end

    # The part name for this table
    # @return [String]
    def pn
      "#{PIVOT_TABLE_CACHE_DEFINITION_PN % (index+1)}"
    end

    # The identifier for this cache
    # @return [Integer]
    def cache_id
      index + 1
    end

    # The relationship id for this pivot table cache definition.
    # @see Relationship#Id
    # @return [String]
    def rId
      pivot_table.relationships.for(self).Id
    end

    # Serializes the object
    # @param [String] str
    # @return [String]
    def to_xml_string(str = String.new)
      str << '<?xml version="1.0" encoding="UTF-8"?>'\
             "<pivotCacheDefinition xmlns=\"#{XML_NS}\" xmlns:r=\"#{XML_NS_R}\" invalid=\"1\" refreshOnLoad=\"1\" recordCount=\"0\">"\
               '<cacheSource type="worksheet">'\
                  "<worksheetSource ref=\"#{pivot_table.range}\" sheet=\"#{pivot_table.data_sheet.name}\"/>"\
               '</cacheSource>'\
                "<cacheFields count=\"#{pivot_table.header_cells_count}\">"
      pivot_table.header_cells.each do |cell|
        str <<   "<cacheField name=\"#{cell.value}\" numFmtId=\"0\">"\
                   '<sharedItems count="0">'\
                   '</sharedItems>'\
                 '</cacheField>'
      end
      str <<   '</cacheFields>'\
             '</pivotCacheDefinition>'
    end

  end
end
