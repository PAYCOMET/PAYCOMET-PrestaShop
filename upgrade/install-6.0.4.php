<?php
/**
* 2007-2015 PrestaShop
*
* NOTICE OF LICENSE
*
* This source file is subject to the Academic Free License (AFL 3.0)
* that is bundled with this package in the file LICENSE.txt.
* It is also available through the world-wide-web at this URL:
* http://opensource.org/licenses/afl-3.0.php
* If you did not receive a copy of the license and are unable to
* obtain it through the world-wide-web, please send an email
* to license@prestashop.com so we can send you a copy immediately.
*
* DISCLAIMER
*
* Do not edit or add to this file if you wish to upgrade PrestaShop to newer
* versions in the future. If you wish to customize PrestaShop for your
* needs please refer to http://www.prestashop.com for more information.
*
*  @author     PAYCOMET <info@paycomet.com>
*  @copyright  2019 PAYTPV ON LINE ENTIDAD DE PAGO S.L
*  @license    http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
*/

if (!defined('_PS_VERSION_')) {
    exit;
}

function upgrade_module_6_0_4($object)
{

    /* Update hooks */
    $object->registerHook('displayPayment');
    $object->registerHook('displayPaymentTop');
    $object->registerHook('displayPaymentReturn');
    $object->registerHook('displayMyAccountBlock');
    $object->registerHook('displayAdminOrder');
    $object->registerHook('displayCustomerAccount');
    $object->registerHook('actionProductCancel');

    try {
        Db::getInstance()->execute(
            '
	    ALTER TABLE `'._DB_PREFIX_.'paytpv_order_info` 
	    ADD COLUMN `paytpv_iduser` INT(11) UNSIGNED NOT NULL DEFAULT 0'
        );
    } catch (exception $e) {
    }

    try {
        Db::getInstance()->execute(
            '
	    ALTER TABLE `'._DB_PREFIX_.'paytpv_order` 
	    ADD COLUMN `payment_status` varchar(255) DEFAULT NULL'
        );
    } catch (exception $e) {
    }

    return true;
}
