class AddDefaultValueToInventory < ActiveRecord::Migration[5.2]
def up
    change_column_default :colors, :inventory, 0
end

def down
    change_column_default :colors, :inventory, nil
end
end
