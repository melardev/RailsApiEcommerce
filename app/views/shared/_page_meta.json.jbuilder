json.(page_meta, :has_next_page)
json.has_prev_page page_meta.has_prev_page
json.has_next_page page_meta.has_next_page

json.offset page_meta.offset

json.requested_page_size page_meta.requested_page_size
json.current_items_count page_meta.current_items_count

json.current_page_number page_meta.current_page
json.next_page_number page_meta.next_page_number
json.prev_page_number page_meta.prev_page_number

json.prev_page_url page_meta.prev_page_url
json.next_page_url page_meta.next_page_url

json.total_items_count page_meta.total_items_count
json.page_count page_meta.page_count

