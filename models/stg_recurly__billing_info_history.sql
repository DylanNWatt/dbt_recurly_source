with base as (
    select *
    from {{ ref('stg_recurly__billing_info_history_tmp') }}
),
fields as (
    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns 
        that are expected/needed (staging_columns from dbt_recurly_source/models/tmp/) and compares it with columns 
        in the source (source_columns from dbt_recurly_source/macros/).
        For more information refer to dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{ fivetran_utils.fill_staging_columns(
            source_columns = adapter.get_columns_in_relation(ref('stg_recurly__billing_info_history_tmp')),
            staging_columns = get_billing_info_history_columns()
        ) }}
    from
        base
),
final as (
    select
        id as billing_id
        , created_at
        , updated_at
        , account_id
        , first_name
        , last_name
        , company
        , vat_number
        , first_name
        , last_name
        , billing_phone
        , billing_street_1
        , billing_street_2
        , billing_city
        , billing_region
        , billing_postal_code
        , billing_country
        , updated_by_ip
        , updated_by_country
        , payment_method_object
        , payment_method_card_type
        , valid as is_valid
    from
        fields
)
select *
from final
