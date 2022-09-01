--To disable this model, set the using_subscription_add_on_history variable within your dbt_project.yml file to False.
{{ config(enabled=var('using_subscription_change_history', True)) }}

with base as (

    select * 
    from {{ ref('stg_recurly__subscription_change_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_recurly__subscription_change_history_tmp')),
                staging_columns=get_coupon_redemption_history_columns()
            )
        }}
    from base
),

final as (
    
    select 
        id as subscription_id,
        _fivetran_synced,
        updated_at,
        plan_id,
        subscription_id,
        object,
        unit_amount,
        quantity,
        activate_at,
        activated,
        created_at,
        deleted_at
    from fields
) 

select *
from final